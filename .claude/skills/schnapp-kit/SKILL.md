```markdown
# schnapp-kit Development Patterns

> Auto-generated skill from repository analysis

## Overview

This skill teaches best practices and workflows for contributing to the `schnapp-kit` JavaScript codebase. It covers coding conventions, file organization, artifact/documentation cleanup, large-scale pruning, and plugin removal. The repository emphasizes maintainability, traceability, and clear commit history using conventional commit messages.

## Coding Conventions

- **File Naming:**  
  Use kebab-case for all file names.
  ```
  // Good
  my-module.js
  cleanup-status.js

  // Bad
  myModule.js
  MyModule.js
  ```

- **Import Style:**  
  Use relative imports for modules.
  ```js
  import { doSomething } from './utils/do-something.js';
  ```

- **Export Style:**  
  Use named exports.
  ```js
  // utils/do-something.js
  export function doSomething() { /* ... */ }
  ```

- **Commit Messages:**  
  Follow conventional commit types (e.g., `refactor:`, `docs:`) with concise, descriptive messages.
  ```
  refactor: remove deprecated language artifacts from core/skills
  docs: update cleanup ledger after artifact pruning
  ```

## Workflows

### doc-cleanup-ledger-update
**Trigger:** When performing a documentation or artifact cleanup, especially large-scale removals or refactors.  
**Command:** `/cleanup-docs`

1. Remove or modify documentation or artifact files (e.g., guides, translations, config mirrors, internal docs, plugins, language artifacts).
2. Update `docs/cleanup/STATUS.md` to reflect the current cleanup status.
3. Update `docs/cleanup/ledger.tsv` to log decisions and actions taken.

**Example:**
```sh
# Remove outdated guides
rm docs/guides/old-guide.md

# Update status and ledger
nano docs/cleanup/STATUS.md
nano docs/cleanup/ledger.tsv
```

---

### large-scale-artifact-pruning
**Trigger:** When deprecating support for a language, editor, plugin, or internal process, or flattening/streamlining the codebase.  
**Command:** `/prune-artifacts`

1. Identify a category of files to remove (e.g., all non-English docs, editor config mirrors, language-specific skills/agents/commands, internal release notes).
2. Remove all files matching the category across relevant directories.
3. Update cleanup tracking files (`STATUS.md`, `ledger.tsv`) as needed.

**Example:**
```sh
# Remove all non-English docs
rm -rf core/docs/ja/*
rm -rf core/docs/de/*

# Remove deprecated plugins
rm -rf core/.agents/old-plugin/
rm -rf vendored/unused-plugin/

# Update tracking files
nano docs/cleanup/STATUS.md
nano docs/cleanup/ledger.tsv
```

---

### remove-vendored-plugin
**Trigger:** When a vendored plugin is marked as disabled or no longer needed.  
**Command:** `/remove-plugin`

1. Remove the plugin's directory and all associated files (README, plugin.json, hooks, handlers, etc.) from `vendored/`.
2. Update cleanup tracking files (`STATUS.md`, `ledger.tsv`) as needed.

**Example:**
```sh
# Remove the plugin directory
rm -rf vendored/old-plugin/

# Update cleanup status and ledger
nano docs/cleanup/STATUS.md
nano docs/cleanup/ledger.tsv
```

## Testing Patterns

- **Test File Naming:**  
  Test files follow the pattern `*.test.*` (e.g., `my-module.test.js`).

- **Framework:**  
  The specific testing framework is not detected; use standard JavaScript testing practices.

**Example:**
```js
// my-module.test.js
import { doSomething } from './my-module.js';

test('doSomething works', () => {
  expect(doSomething()).toBe(true);
});
```

## Commands

| Command          | Purpose                                                           |
|------------------|-------------------------------------------------------------------|
| /cleanup-docs    | Track and record documentation or artifact cleanup actions        |
| /prune-artifacts | Remove large groups of related files as part of codebase pruning  |
| /remove-plugin   | Remove a vendored plugin that is disabled or deprecated           |
```