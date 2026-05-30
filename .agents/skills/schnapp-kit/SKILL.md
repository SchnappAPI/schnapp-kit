```markdown
# schnapp-kit Development Patterns

> Auto-generated skill from repository analysis

## Overview
This skill covers the core development patterns and workflows used in the `schnapp-kit` JavaScript codebase. It documents coding conventions, file organization, and the primary workflows for codebase cleanup and artifact removal. By following these guidelines, contributors can maintain consistency and efficiently manage large-scale refactoring or cleanup tasks.

## Coding Conventions

- **File Naming:**  
  Use kebab-case for all file and directory names.  
  _Example:_  
  ```
  my-component.js
  utils/helpers.js
  ```

- **Import Style:**  
  Use relative imports for referencing modules within the codebase.  
  _Example:_  
  ```js
  import { doThing } from './utils/do-thing.js';
  ```

- **Export Style:**  
  Prefer named exports over default exports.  
  _Example:_  
  ```js
  // utils/do-thing.js
  export function doThing() { /* ... */ }
  ```

- **Commit Messages:**  
  Use [Conventional Commits](https://www.conventionalcommits.org/) with prefixes such as `refactor` and `docs`.  
  _Example:_  
  ```
  refactor: reorganize helper functions for clarity
  docs: update usage instructions in README
  ```

## Workflows

### Record Cleanup Decision Ledger
**Trigger:** When performing a significant codebase cleanup or refactor that removes, relocates, or changes the status of many files.  
**Command:** `/record-cleanup`

1. Edit or remove a large set of files (docs, configs, code, etc.) as part of a cleanup or refactor.
2. Update `docs/cleanup/ledger.tsv` to record the decision and list the affected files.
3. Update `docs/cleanup/STATUS.md` to reflect the new status of the cleanup effort.

_Example entry in `ledger.tsv`:_
```
2024-06-12	refactor	remove legacy agent files	core/agents/legacy-*.md
```

### Bulk Remove Obsolete or Non-Targeted Artifacts
**Trigger:** When deprecating support for platforms, languages, or tools, or when cleaning up legacy/internal artifacts.  
**Command:** `/bulk-remove-artifacts`

1. Identify a class of files to remove (e.g., non-English docs, editor configs, language-specific agents/skills, internal docs, plugins, root scaffolding).
2. Delete all matching files from the repository.
3. Update `docs/cleanup/ledger.tsv` and `docs/cleanup/STATUS.md` to record the removal and rationale.

_Example:_
- Remove all non-English documentation:
  ```
  rm -rf core/docs/fr/*
  ```
- Update `ledger.tsv`:
  ```
  2024-06-12	bulk-remove	remove non-English docs	core/docs/fr/*
  ```

## Testing Patterns

- **Test File Naming:**  
  Test files follow the pattern `*.test.*` (e.g., `my-component.test.js`).

- **Framework:**  
  No specific testing framework detected.  
  _Example test file:_
  ```js
  // math-utils.test.js
  import { add } from './math-utils.js';

  test('add returns correct sum', () => {
    expect(add(2, 3)).toBe(5);
  });
  ```

## Commands

| Command                | Purpose                                                                 |
|------------------------|-------------------------------------------------------------------------|
| /record-cleanup        | Record a major codebase cleanup or refactor decision in the ledger.      |
| /bulk-remove-artifacts | Remove large sets of obsolete or non-targeted files and update records.  |
```
