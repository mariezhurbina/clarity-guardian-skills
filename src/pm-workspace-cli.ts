import { readFileSync } from 'node:fs';
import { bundledPath } from './bundled-files';
import { createWorkspaceTools, WORKSPACE_TOOLS } from './pm-workspace-tools';
import { isTaskRow } from './task-model';
import { makeCliError, readJsonFile, readTextFile } from './utils';

function optionalPath(request: Record<string, unknown>, key: string): string | undefined {
  const value = request[key];
  if (value === undefined) return undefined;
  if (typeof value !== 'string' || !value.trim()) throw makeCliError(`Укажи путь в поле ${key}.`);
  return value;
}

function main(): void {
  const requestPath = process.argv[2];
  if (!requestPath) throw makeCliError('Укажи путь к JSON-запросу или - для чтения со stdin.');

  const request: unknown = requestPath === '-'
    ? JSON.parse(readFileSync(0, 'utf-8'))
    : readJsonFile(requestPath);
  if (!isTaskRow(request) || typeof request.tool !== 'string' || !isTaskRow(request.args) ||
      !WORKSPACE_TOOLS.some(({ name }) => name === request.tool)) {
    throw makeCliError('Передай имя инструмента в tool и объект параметров в args.');
  }

  const tools = createWorkspaceTools(process.cwd(), {
    demoDir: bundledPath('data'),
    input: optionalPath(request, 'input'),
    baseline: optionalPath(request, 'baseline'),
  });
  const args = { ...request.args };

  if (request.tool === 'save_drafts') {
    if (!Array.isArray(request.searches) || request.searches.length === 0) {
      throw makeCliError('Передай в searches массивы запросов, использованных для prepare_meeting.');
    }
    for (const queries of request.searches) {
      tools.call('prepare_meeting', { dataset: args.dataset, queries });
    }
    const notesFile = optionalPath(request, 'notesFile');
    if (notesFile) args.notes = readTextFile(notesFile);
  }

  const result = tools.call(request.tool, args);
  if ('error' in result) throw makeCliError(String(result.error));
  console.log(JSON.stringify(result, null, 2));
}

try {
  main();
} catch (error) {
  console.error(error instanceof Error ? error.message : String(error));
  process.exitCode = 1;
}
