import { existsSync } from 'node:fs';
import path from 'node:path';
import type { TemplateLanguage } from './types';

const parent = path.dirname(__dirname);
const root = existsSync(path.join(parent, 'package.json')) ? parent : path.dirname(parent);

export function bundledPath(...parts: string[]): string {
  return path.join(root, ...parts);
}

export function templatePath(baseName: string, language: TemplateLanguage): string {
  const file = language === 'en' ? `${baseName}.en.md` : `${baseName}.md`;
  const local = path.join('templates', file);
  return existsSync(local) ? local : bundledPath('templates', file);
}
