// wingman/commands/next.js
import fs from 'fs';
import path from 'path';
import inquirer from 'inquirer';
import chalk from 'chalk';

const STATE_PATH = path.resolve(process.cwd(), '.wingman/state');

export default async function next() {
  console.log(chalk.bold('\n🧠 Wingman Next Move Generator'));

  const { focus, notes } = await inquirer.prompt([
    {
      type: 'input',
      name: 'focus',
      message: 'What\'s the focus of your next task?',
      validate: input => input.length > 0 || 'Task description is required.'
    },
    {
      type: 'input',
      name: 'notes',
      message: 'Optional notes to remind yourself later:'
    }
  ]);

  const phase = focus
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, '-')
    .replace(/^-|-$/g, '');

  console.log(`\n✔️  Phase name: ${chalk.cyan(phase)}`);

  // Suggest terminal command
  console.log(`\n${chalk.green('🔧 Terminal command:')}`);
  console.log(`wingman change ${phase}`);

  // Suggest GPT prompt
  console.log(`\n${chalk.green('🧠 GPT thread prompt:')}`);
  console.log(`Wingman, I’m in thread: "${focus}"`);
  console.log(`Phase: ${phase}`);
  console.log(`Source: server`);
  if (notes) console.log(`\nNotes: ${notes}`);

  // Optionally write phase as draft (could later be activated)
  const draftLog = path.resolve(process.cwd(), '.wingman/next.yml');
  const draftEntry = `
- phase: ${phase}
  focus: "${focus}"
  notes: "${notes || ''}"
  generated: ${new Date().toISOString()}
`;

  fs.appendFileSync(draftLog, draftEntry);
  console.log(`\n📥 Draft saved to .wingman/next.yml\n`);
}

// To wire this into your CLI: add to your index.js command map
// program.command('next').description('Prompt for next Wingman phase').action(next);
