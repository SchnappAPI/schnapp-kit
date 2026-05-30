```markdown
# schnapp-kit Development Patterns

> Auto-generated skill from repository analysis

## Overview
This skill documents the core development conventions and maintenance workflows used in the `schnapp-kit` JavaScript codebase. It covers file organization, coding style, commit message patterns, and step-by-step instructions for common repository cleanup and configuration removal tasks. Use this guide to contribute code, maintain documentation, and manage project configurations in a consistent and efficient way.

## Coding Conventions

### File Naming
- Use **kebab-case** for all file names.
  - Example: `my-component.js`, `user-profile.test.js`

### Imports
- Use **relative import paths**.
  - Example:
    ```javascript
    import { fetchData } from './utils/fetch-data.js';
    ```

### Exports
- Use **named exports** (not default exports).
  - Example:
    ```javascript
    // utils/math.js
    export function add(a, b) { return a + b; }
    export function subtract(a, b) { return a - b; }
    ```

### Commit Messages
- Follow **conventional commit** style.
- Common prefixes: `refactor`, `docs`
- Example:
  ```
  refactor: simplify fetch logic in user-profile.js
  docs: update API usage section in README
  ```

## Workflows

### Documentation Cleanup and Ledger Update
**Trigger:** When deprecating or removing a category of docs/configs (e.g., non-English translations, editor configs, internal guides) as part of a cleanup or refactor.  
**Command:** `/cleanup-section`

1. Identify a group of files to remove (by section, language, or editor).
2. Delete all files in the identified group.
3. Update `docs/cleanup/STATUS.md` to reflect the removal.
4. Update `docs/cleanup/ledger.tsv` to record decisions and removals.

**Files involved:**
- `core/docs/*`
- `core/.*/**`
- `docs/cleanup/STATUS.md`
- `docs/cleanup/ledger.tsv`

**Example:**
```bash
# Remove all non-English docs
rm -rf core/docs/es/
rm -rf core/docs/fr/
# Update cleanup status and ledger
vim docs/cleanup/STATUS.md
vim docs/cleanup/ledger.tsv
```

---

### Removal of Internal or Legacy Configs
**Trigger:** When shifting project focus or deprecating legacy/internal infrastructure (e.g., dropping support for non-primary editors or CI systems).  
**Command:** `/remove-internal-configs`

1. Identify internal or legacy config files to remove (e.g., `.github/`, `.claude/`).
2. Delete all related files.
3. Update `docs/cleanup/STATUS.md` and `docs/cleanup/ledger.tsv` to reflect the change.

**Files involved:**
- `core/.github/**`
- `core/.claude/**`
- `docs/cleanup/STATUS.md`
- `docs/cleanup/ledger.tsv`

**Example:**
```bash
# Remove legacy CI configs
rm -rf core/.github/
rm -rf core/.claude/
# Update cleanup status and ledger
vim docs/cleanup/STATUS.md
vim docs/cleanup/ledger.tsv
```

## Testing Patterns

- Test files use the pattern: `*.test.*`
  - Example: `user-profile.test.js`
- The testing framework is **unknown**; check existing test files for conventions.
- Place tests alongside source files or in a dedicated test directory, matching the kebab-case naming.

**Example:**
```javascript
// user-profile.test.js
import { getUserProfile } from './user-profile.js';

test('should fetch user profile', () => {
  // ...test logic...
});
```

## Commands

| Command                  | Purpose                                                      |
|--------------------------|--------------------------------------------------------------|
| /cleanup-section         | Remove a group of documentation/config files and update ledger|
| /remove-internal-configs | Remove legacy/internal config files and update ledger         |
```