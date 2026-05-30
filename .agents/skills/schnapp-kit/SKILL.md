```markdown
# schnapp-kit Development Patterns

> Auto-generated skill from repository analysis

## Overview
This skill provides guidance for contributing to the `schnapp-kit` JavaScript codebase. It covers coding conventions, file organization, and repeatable workflows for documentation and configuration cleanup. The repository is framework-agnostic, uses conventional commit messages, and emphasizes maintainability through structured cleanup processes.

## Coding Conventions

- **File Naming:**  
  Use `kebab-case` for all file names.
  ```
  // Good
  core/utils/sort-array.js

  // Bad
  core/utils/sortArray.js
  ```

- **Import Style:**  
  Use relative imports for modules within the codebase.
  ```js
  // Good
  import { sortArray } from './sort-array.js';

  // Bad
  import { sortArray } from 'core/utils/sort-array.js';
  ```

- **Export Style:**  
  Use named exports.
  ```js
  // Good
  export function sortArray(arr) { ... }

  // Bad
  export default function sortArray(arr) { ... }
  ```

- **Commit Messages:**  
  Use [Conventional Commits](https://www.conventionalcommits.org/) with prefixes such as `refactor`, `docs`, etc.
  ```
  refactor: simplify array sorting logic
  docs: remove outdated adapter guide
  ```

## Workflows

### Documentation Section Removal
**Trigger:** When a documentation section (such as adapter guides, localized translations, or internal project docs) is deprecated or targeted for removal.  
**Command:** `/remove-doc-section`

1. Identify all files in the targeted documentation section (e.g., `core/docs/ANTIGRAVITY-GUIDE.md`, `core/docs/ja-JP/*`, `core/docs/releases/*`).
2. Delete all files matching the section's pattern.
3. Update cleanup tracking files (`docs/cleanup/ledger.tsv`, `docs/cleanup/STATUS.md`) to record the removal.
4. Optionally, update review aids or index files to reflect the change.

**Example:**
```sh
# Remove Japanese docs
rm -rf core/docs/ja-JP/
# Log removal
echo "2024-06-11\tRemoved ja-JP docs\tcore/docs/ja-JP/*" >> docs/cleanup/ledger.tsv
```

---

### Editor Config Mirror Removal
**Trigger:** When support for alternative editors is dropped or consolidated to a primary platform.  
**Command:** `/remove-editor-mirrors`

1. Identify all files and folders under editor-specific config directories (e.g., `core/.cursor/*`, `core/.kiro/*`, etc.).
2. Delete all files in these directories.
3. Update cleanup tracking files (`docs/cleanup/ledger.tsv`, `docs/cleanup/STATUS.md`) to log the removal.

**Example:**
```sh
# Remove all editor mirrors
rm -rf core/.cursor/ core/.kiro/ core/.opencode/ core/.agents/ core/.codebuddy/ core/.codex/ core/.codex-plugin/ core/.trae/ core/.zed/ core/.gemini/ core/.qwen/
# Log removal
echo "2024-06-11\tRemoved editor mirrors\tcore/.cursor/* core/.kiro/* ..." >> docs/cleanup/ledger.tsv
```

---

### Cleanup Tracking Update
**Trigger:** Whenever files are removed or major documentation/structural changes are made as part of a cleanup.  
**Command:** `/update-cleanup-ledger`

1. Edit `docs/cleanup/PLAN.md` to describe the cleanup plan.
2. Edit `docs/cleanup/STATUS.md` to reflect current progress.
3. Edit `docs/cleanup/ledger.tsv` to record specific decisions and file removals.

**Example:**
```markdown
# docs/cleanup/PLAN.md
## June 2024 Cleanup
- Remove deprecated documentation sections
- Drop support for non-primary editors

# docs/cleanup/STATUS.md
- [x] Removed ja-JP docs
- [x] Removed editor mirrors

# docs/cleanup/ledger.tsv
2024-06-11	Removed ja-JP docs	core/docs/ja-JP/*
2024-06-11	Removed editor mirrors	core/.cursor/* core/.kiro/* ...
```

## Testing Patterns

- **Test File Naming:**  
  Test files follow the pattern `*.test.*` (e.g., `sort-array.test.js`).
- **Framework:**  
  No specific testing framework detected; use standard JavaScript testing practices.
- **Example:**
  ```js
  // sort-array.test.js
  import { sortArray } from './sort-array.js';

  test('sorts numbers in ascending order', () => {
    expect(sortArray([3, 1, 2])).toEqual([1, 2, 3]);
  });
  ```

## Commands

| Command                | Purpose                                                      |
|------------------------|--------------------------------------------------------------|
| /remove-doc-section    | Remove an entire documentation section/category              |
| /remove-editor-mirrors | Remove all non-primary editor configuration/skill files      |
| /update-cleanup-ledger | Update cleanup plan, status, and ledger documentation files  |
```
