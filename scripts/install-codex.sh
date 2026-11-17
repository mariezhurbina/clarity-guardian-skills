#!/bin/sh

install_clarity_guardian() (
  set -eu
  root=${CLARITY_GUARDIAN_INSTALL_DIR:-"$HOME/.local/share/clarity-guardian-codex"}
  skills=${CLARITY_GUARDIAN_SKILL_DIR:-"$HOME/.agents/skills"}
  source=${CLARITY_GUARDIAN_INSTALL_SOURCE:-https://github.com/mariezhurbina/clarity-guardian-skills.git}
  engine=${CLARITY_GUARDIAN_ENGINE_SOURCE:-https://github.com/mariezhurbina/clarity-guardian.git}
  engine_commit=382a22b0189f449256a687007c3c986d6e403c55
  names='clarity-guardian agent-handoff change-review meeting-drafts'

  for tool in git node npm; do
    command -v "$tool" >/dev/null || { printf '%s is required.\n' "$tool" >&2; exit 1; }
  done
  node -e 'if (+process.versions.node.split(".")[0] < 20) { console.error("Node.js 20 or newer is required."); process.exit(1); }'
  for directory in "$root" "$skills"; do
    case "$directory" in
      /*) ;;
      *) printf 'Expected an absolute installation path: %s\n' "$directory" >&2; exit 1 ;;
    esac
  done

  current="$root/current"
  if [ -L "$current" ] || [ -e "$current" ]; then
    case "$(readlink "$current" 2>/dev/null || true)" in
      "$root/versions/"*) ;;
      *) printf 'Installation path is already in use: %s\n' "$current" >&2; exit 1 ;;
    esac
  fi
  for name in $names; do
    link="$skills/$name"
    if [ -L "$link" ] || [ -e "$link" ]; then
      [ "$(readlink "$link" 2>/dev/null || true)" = "$current/.agents/skills/$name" ] || {
        printf 'Skill already exists at %s. Move it before installing.\n' "$link" >&2
        exit 1
      }
    fi
  done

  mkdir -p "$root/versions" "$skills"
  temp=$(mktemp -d "$root/.install.XXXXXXXX")
  trap 'rm -rf "$temp"' EXIT
  trap 'exit 1' HUP INT TERM
  git clone --quiet --depth 1 --single-branch --branch main -- "$source" "$temp/skill"
  version="$root/versions/$(git -C "$temp/skill" rev-parse HEAD)"
  if [ ! -d "$version" ]; then
    git init --quiet "$temp/source"
    git -C "$temp/source" fetch --quiet --depth 1 "$engine" "$engine_commit"
    git -C "$temp/source" checkout --quiet --detach FETCH_HEAD
    git -C "$temp/source" apply "$temp/skill/scripts/runtime.patch"
    engine_skills="$temp/source/.agents/skills"
    main_skill="$engine_skills/clarity-guardian"
    mkdir -p "$main_skill/scripts"
    cp "$temp/skill/SKILL.md" "$main_skill/SKILL.md"
    cp "$temp/skill/scripts/run.cjs" "$main_skill/scripts/run.cjs"
    cp -R "$temp/skill/references" "$main_skill/"
    for name in agent-handoff change-review meeting-drafts; do
      mkdir -p "$engine_skills/$name"
      cp "$temp/skill/shortcuts/$name/SKILL.md" "$engine_skills/$name/SKILL.md"
    done
    (cd "$temp/source" && npm ci --include=dev --no-audit --no-fund && npm run build)
    node - "$temp/source" "$version" <<'JS'
const { existsSync, renameSync } = require('node:fs');
const [source, target] = process.argv.slice(2);
try { renameSync(source, target); } catch (error) {
  if (!['EEXIST', 'ENOTEMPTY'].includes(error.code) || !existsSync(target)) throw error;
}
JS
  fi
  test -f "$version/dist/pm-workspace-cli.js"
  for name in $names; do
    test -f "$version/.agents/skills/$name/SKILL.md"
    link="$skills/$name"
    target="$current/.agents/skills/$name"
    if [ ! -L "$link" ]; then
      ln -s "$target" "$link" || [ "$(readlink "$link")" = "$target" ]
    fi
  done

  ln -s "$version" "$temp/current"
  node -e 'require("node:fs").renameSync(process.argv[1], process.argv[2]);' "$temp/current" "$current"
  printf 'Installed $clarity-guardian and its shortcuts in %s.\n' "$skills"
  printf 'Open a new Codex chat in any local project.\n'
)

install_clarity_guardian "$@"
