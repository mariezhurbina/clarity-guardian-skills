# Команды Clarity Guardian

Запускайте команды из корня проекта. Для рабочих примеров замените пути на исходные файлы пользователя, а для результатов выберите отдельное имя в `reports/`.

## Задача, спринт и релиз

```sh
npm run --silent analyze -- --input "task.json" --json-file "reports/analysis.json" --comment-file "reports/analysis.md"
OPENAI_API_KEY='' npm run --silent generate:test-checklist -- --input "task.json" --comment-file "reports/checklist.md"
npm run --silent v2:report -- --input "tasks.json" --out-dir "reports/backlog"
```

Первая команда анализирует одну карточку или GitHub Issue/PR payload. Вторая создаёт QA-чек-лист по локальному шаблону. Для сводки с утверждённым снимком передайте `--baseline "approved.json"` в `v2:report`. Для демо SMART используйте `npm run smart:demo`.

Для отдельных отчётов используйте шаблон `npm run --silent <команда> -- --input "tasks.json" --output "reports/<отчёт>.md"`. Для `project:pulse` выберите `.html`.

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

- Для проверки готовности к передаче используйте [Agent Handoff](../../agent-handoff/SKILL.md).
- Для сравнения с согласованным снимком используйте [Change Review](../../change-review/SKILL.md).
- Для работы с заметками и открытыми вопросами используйте [Meeting Drafts](../../meeting-drafts/SKILL.md) через проектный MCP. `npm run build` создаёт исполняемый сервер.
- Для перепроверки одобренной очереди выполните `npm run --silent drafts:check -- --approved "approved-drafts.json" --input "data/local/tasks.json"` со свежей выгрузкой.
- Для локальной сводки PM Agent используйте `npm run --silent pm:agent -- --input "tasks.json" --output "reports/pm-agent.md"`. Подключение другого MCP-клиента и отдельный режим API описаны в [README](../../../../README.md#pm-agent).

## Источники и синхронизация

```sh
npm run --silent backlog:import -- --source linear --team ENG --output "data/local/tasks.json"
npm run --silent backlog:import -- --source gitlab --project group/project --output "data/local/tasks.json"
npm run --silent fetch:yandex -- --output "data/local/tasks.json"
```

Проверяйте выбранную команду, проект или очередь. Имена переменных окружения для доступа указаны в [README](../../../../README.md#интеграции).

Для GitHub и Jira локальные результаты готовят `analyze` и `generate:test-checklist`. Команды `sync:github` и `sync:jira` публикуют их в трекере. Аргументы синхронизации указаны в [README](../../../../README.md#github).
