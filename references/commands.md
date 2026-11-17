# Команды Clarity Guardian

Запускайте команды из текущего проекта. Подставьте абсолютный путь к `scripts/run.cjs` из папки скилла вместо `$runner`. Для рабочих примеров замените пути на исходные файлы пользователя, а для результатов выберите отдельное имя в `reports/`.

## Задача, спринт и релиз

```sh
node "$runner" analyze --input "task.json" --json-file "reports/analysis.json" --comment-file "reports/analysis.md"
OPENAI_API_KEY='' node "$runner" generate:test-checklist --input "task.json" --comment-file "reports/checklist.md"
node "$runner" v2:report --input "tasks.json" --out-dir "reports/backlog"
```

Первая команда анализирует одну карточку или GitHub Issue/PR payload. Вторая создаёт QA-чек-лист по локальному шаблону. Для сводки с утверждённым снимком передайте `--baseline "approved.json"` в `v2:report`. Для демо SMART передайте в `--input` результат `node "$runner" asset smart-demo-tasks.json`. Для ретро с историей статусов используйте `node "$runner" asset demo_tasks.json`.

Для отдельных отчётов используйте шаблон `node "$runner" <команда> --input "tasks.json" --output "reports/<отчёт>.md"`. Для `project:pulse` выберите `.html`.

| Команда | Результат |
| --- | --- |
| `project:pulse` | Сводка проекта, риски, приоритетные действия |
| `data:doctor` | Покрытие полей, дубли, даты и отброшенные строки |
| `task:health` | Профили задач, ясность, SMART и следующие шаги |
| `quality:gate` | Проверка порогов качества и блокирующих правил |
| `risk` | Delivery-риски и их причины |
| `readiness` | Definition of Ready и Definition of Done |
| `sprint-health` | Состояние спринта. При необходимости передайте `--sprint` |
| `team:handoff` | Что передать аналитику, разработчику и QA |
| `release:guard` | Решение о готовности релиза, QA-проверки и откат |
| `bug:quick-fix` | Очередь быстрых исправлений и задачи для ручного ревью |
| `ownership:risk` | Риски без владельца и концентрация риска |
| `action:plan` | Приоритетные задачи для уточнения |
| `refinement:agenda` | Повестка, вопросы и роли участников |
| `stakeholder:update` | Статус, риски, запросы и следующие действия |
| `retro` | Lead time, cycle time, возвраты и узкие места |
| `evidence:brief` | Гипотезы, проверяемость и пробелы в доказательствах |
| `decision:ledger` | Связь решений с исходными данными, владельцами и проверками |

## PM Agent, встречи и согласованные изменения

- Для готовности к передаче и сравнения снимков используй `agent:handoff` и `change:review`. Решения по обоим сценариям описаны в [SKILL.md](../SKILL.md).

```sh
node "$runner" agent:handoff --input "tasks.json" --output "reports/handoff.json"
node "$runner" change:review --baseline "approved.json" --input "tasks.json" --output "reports/change-review.json"
```

- Для заметок и открытых вопросов используй [схему запросов](meetings.md).

- Для перепроверки одобренной очереди выполните `node "$runner" drafts:check --approved "approved-drafts.json" --input "data/local/tasks.json"` со свежей выгрузкой.
- Для локальной сводки PM Agent используйте `node "$runner" pm:agent --input "tasks.json" --output "reports/pm-agent.md"`. Подключение другого MCP-клиента и отдельный режим API описаны в [README](https://github.com/mariezhurbina/clarity-guardian#pm-agent).

## Источники и синхронизация

```sh
node "$runner" backlog:import --source linear --team ENG --output "data/local/tasks.json"
node "$runner" backlog:import --source gitlab --project group/project --output "data/local/tasks.json"
node "$runner" fetch:yandex --output "data/local/tasks.json"
```

Проверяйте выбранную команду, проект или очередь. Имена переменных окружения для доступа указаны в [README](https://github.com/mariezhurbina/clarity-guardian#интеграции).

Для GitHub и Jira локальные результаты готовят `analyze` и `generate:test-checklist`. Команды `sync:github` и `sync:jira` публикуют их в трекере. Аргументы синхронизации указаны в [README](https://github.com/mariezhurbina/clarity-guardian#github).
