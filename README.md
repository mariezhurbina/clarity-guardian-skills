# Clarity Guardian Skills

Два скилла для Codex, которые используют JSON-отчёты Clarity Guardian.

| Скилл | Для чего нужен |
| --- | --- |
| [Agent Handoff](skills/agent-handoff/SKILL.md) | Проверяет, готова ли задача к передаче coding-агенту. Возвращает бриф, вопросы к постановке или причины ручного ревью. |
| [Change Review](skills/change-review/SKILL.md) | Сверяет согласованное ТЗ с текущей выгрузкой. Показывает изменившиеся поля и задачи, которые появились или отсутствуют в текущем снимке. |

## Установка

Для запуска нужен локальный checkout Clarity Guardian с командами `agent:handoff` и `change:review`, Node.js 20+ и локальный Codex. Условия использования CLI указаны в лицензии исходного проекта. [Clarity Guardian](https://github.com/mariezhurbina/clarity-guardian) · [Лицензия CLI](https://github.com/mariezhurbina/clarity-guardian/blob/main/LICENSE)

Клонируйте этот репозиторий рядом с Clarity Guardian. Если ваша копия Clarity Guardian лежит в другой папке, подставьте её путь.

```sh
git clone https://github.com/mariezhurbina/clarity-guardian-skills.git
cd clarity-guardian
mkdir -p .agents/skills
cp -R ../clarity-guardian-skills/skills/. .agents/skills/
npm ci
```

## Запуск

Откройте корень Clarity Guardian в Codex и попробуйте демо.

```text
$agent-handoff Проверь CG-203 и CG-204 на демо.
$change-review Сравни согласованное и текущее ТЗ на демо.
```

Для работы со своим бэклогом передайте путь к JSON-выгрузке или положите её в `data/local/tasks.json`. Для сверки ТЗ укажите согласованный снимок или положите его в `data/local/approved.json`. Выгружайте оба снимка с одинаковыми фильтрами и стабильными ключами задач. Скиллы сохраняют отчёты в `reports/` внутри Clarity Guardian.
