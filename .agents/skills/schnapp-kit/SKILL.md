```markdown
# schnapp-kit Development Patterns

> Auto-generated skill from repository analysis

## Overview
This skill teaches the core development patterns, coding conventions, and maintenance workflows used in the `schnapp-kit` JavaScript codebase. The repository is framework-agnostic and emphasizes clear file organization, consistent code style, and systematic artifact cleanup. It also documents how to track and record large-scale changes for long-term maintainability.

## Coding Conventions

### File Naming
- Use **kebab-case** for all file and directory names.
  - Example: `my-component.js`, `utils/helpers.js`

### Import Style
- Use **relative imports** for modules within the codebase.
  ```js
  import { doSomething } from './utils/do-something.js';
  ```

### Export Style
- Use **named exports** (not default exports).
  ```js
  // In utils/do-something.js
  export function doSomething() { ... }

  // In another file
  import { doSomething } from './utils/do-something.js';
  ```

### Commit Messages
- Follow **conventional commit** format.
  - Prefixes: `refactor`, `docs`
  - Example: `refactor: simplify artifact pruning logic`

## Workflows

### Large-Scale Artifact Pruning
**Trigger:** When a feature, language, or integration is deprecated or removed from support, and all related files must be deleted from the repository.  
**Command:** `/prune-artifacts`

1. **Identify** all files related to the deprecated feature/language/integration using directory and filename patterns.
2. **Remove** these files in a single commit, grouped by logical section (e.g., docs, configs, skills, plugins, root files).
3. **Update** cleanup tracking files:
    - `docs/cleanup/STATUS.md`
    - `docs/cleanup/ledger.tsv`
4. **Repeat** for each logical section as needed.

**Files Involved:**
- `core/docs/**`
- `core/.agents/**`
- `core/.cursor/**`
- `core/.kiro/**`
- `core/.opencode/**`
- `core/.github/**`
- `core/.claude/**`
- `core/agents/**`
- `core/commands/**`
- `core/rules/**`
- `core/skills/**`
- `vendored/**`
- `core/*.{md,json,sh,js,py,yml,yaml,toml}`
- `docs/cleanup/STATUS.md`
- `docs/cleanup/ledger.tsv`

### Cleanup Ledger and Status Update
**Trigger:** Whenever a bulk file removal, refactor, or documentation change is made that affects project structure or artifact inventory.  
**Command:** `/update-cleanup-ledger`

1. **Perform** the main change (e.g., remove files, refactor structure).
2. **Edit** `docs/cleanup/STATUS.md` to reflect the new state of the project.
3. **Edit** `docs/cleanup/ledger.tsv` to record decisions, removed files, and rationale.
4. **Commit** the changes together.

**Files Involved:**
- `docs/cleanup/STATUS.md`
- `docs/cleanup/ledger.tsv`

## Testing Patterns

- Test files use the pattern: `*.test.*` (e.g., `foo.test.js`)
- The specific testing framework is **unknown**; check existing test files for conventions.
- Example test file name: `utils/do-something.test.js`

## Commands

| Command                | Purpose                                                      |
|------------------------|--------------------------------------------------------------|
| /prune-artifacts       | Bulk remove deprecated or unsupported features/artifacts      |
| /update-cleanup-ledger | Update cleanup tracking files after major changes             |
```