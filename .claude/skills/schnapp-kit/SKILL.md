```markdown
# schnapp-kit Development Patterns

> Auto-generated skill from repository analysis

## Overview
This skill teaches the core development patterns, coding conventions, and maintenance workflows used in the `schnapp-kit` TypeScript codebase. It covers file naming, import/export styles, commit conventions, documentation cleanup processes, and testing patterns to ensure consistency and maintainability.

## Coding Conventions

### File Naming
- Use **camelCase** for file names.
  - Example: `myModule.ts`, `userProfile.test.ts`

### Import Style
- Use **relative imports** for referencing modules within the project.
  - Example:
    ```typescript
    import { myFunction } from './utils';
    ```

### Export Style
- Use **named exports** rather than default exports.
  - Example:
    ```typescript
    // utils.ts
    export function myFunction() { /* ... */ }
    ```

### Commit Messages
- Follow **conventional commit** format.
- Common prefixes: `refactor`, `docs`
- Example:
  ```
  docs: update adapter documentation for new API
  refactor: simplify user authentication logic
  ```

## Workflows

### Documentation Cleanup and Ledger Update
**Trigger:** When you need to remove outdated, unused, or non-relevant documentation and keep a record of the cleanup process.  
**Command:** `/cleanup-docs`

1. **Identify** documentation files to remove (e.g., adapter guides, localized docs).
2. **Delete** the identified files from their respective directories.
3. **Update or create** entries in `docs/cleanup/ledger.tsv` to record what was removed and why.
   - Example entry:
     ```
     core/docs/old-adapter.md	Removed	Obsolete after v2.0
     ```
4. **Update** `docs/cleanup/STATUS.md` to reflect the current cleanup status.
   - Example addition:
     ```markdown
     ## June 2024
     - Removed old adapter guides as per migration plan.
     ```
5. **Optionally**, update `docs/cleanup/PLAN.md` with future cleanup intentions.

**Files Involved:**
- `core/docs/*`
- `docs/cleanup/ledger.tsv`
- `docs/cleanup/STATUS.md`
- `docs/cleanup/PLAN.md`

**Frequency:** ~2x/month

## Testing Patterns

- Test files follow the `*.test.*` naming convention.
  - Example: `userProfile.test.ts`
- Testing framework is **unknown** (not detected), but tests are colocated with source files or in dedicated test directories.

## Commands

| Command        | Purpose                                                        |
|----------------|----------------------------------------------------------------|
| /cleanup-docs  | Initiate documentation cleanup and update the cleanup ledger.  |
```
