#!/usr/bin/env node
import { Command } from 'commander';
import next from './commands/next.js';

const program = new Command();

program
  .command('next')
  .description('Prompt for next Wingman phase')
  .action(next);

program.parse(process.argv);
