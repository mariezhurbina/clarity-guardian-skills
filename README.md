# Clarity Guardian Skill

Основной скилл для Codex находится в корне репозитория. В нём описаны выбор проверки, работа с доказательствами и результат для каждого сценария. [Открыть SKILL.md](SKILL.md)

Для расчётов скилл вызывает CLI из основного проекта Clarity Guardian. Установщик скачивает закреплённую версию движка, применяет адаптацию для запуска из любого каталога и собирает её локально. [Репозиторий движка](https://github.com/mariezhurbina/clarity-guardian)

## Установка

На macOS или Linux с Node.js 20+, Git и curl выполни одну команду.

```sh
curl -fsSL https://raw.githubusercontent.com/mariezhurbina/clarity-guardian-skills/main/scripts/install-codex.sh | sh
```

Открой новый чат Codex в любом локальном проекте. Начни с `$clarity-guardian Проверь готовность релиза на демо` или передай свой бэклог и заметки встречи. Отчёты сохраняются в `reports/` текущего проекта. Повтор той же команды обновляет установку.

Установщик также регистрирует прежние имена `$agent-handoff`, `$change-review` и `$meeting-drafts` как короткие способы вызвать соответствующие части основного скилла.

## Материалы

- [Команды и форматы отчётов](references/commands.md)
- [Схема запросов для заметок встреч](references/meetings.md)
- [Лицензия](LICENSE)
