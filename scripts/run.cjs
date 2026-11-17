const { spawnSync } = require('node:child_process');
const { existsSync } = require('node:fs');
const path = require('node:path');

const root = path.resolve(__dirname, '../../../..');
const data = path.join(root, 'data');

function main([command, ...args]) {
  if (command === 'asset') {
    const [name] = args;
    const file = path.join(data, name || '');
    if (!name || name !== path.basename(name) || !/^[a-z0-9][a-z0-9._-]*\.(json|txt)$/.test(name) || !existsSync(file)) {
      throw new Error('Укажи имя демо-файла из data/.');
    }
    console.log(file);
    return;
  }

  if (command === 'demo') {
    command = 'v2:report';
    args = ['--demo', ...args];
  }

  const scripts = require(path.join(root, 'package.json')).scripts;
  const match = /^npm run build --silent && node (dist\/[a-z0-9-]+\.js)$/.exec(scripts[command] || '');
  if (!match) throw new Error(`Неизвестная команда Clarity Guardian: ${command || '(пусто)'}.`);

  const script = path.join(root, match[1]);
  if (!existsSync(script)) throw new Error(`Собери Clarity Guardian командой npm run build в ${root}.`);

  const result = spawnSync(process.execPath, [script, ...args], { stdio: 'inherit' });
  if (result.error) throw result.error;
  process.exitCode = result.status ?? 1;
}

try {
  main(process.argv.slice(2));
} catch (error) {
  console.error(error.message);
  process.exitCode = 1;
}
