```markdown
# schnapp-kit Development Patterns

> Auto-generated skill from repository analysis

## Overview
This skill teaches you the core development patterns and conventions used in the `schnapp-kit` TypeScript codebase. You'll learn about file naming, import/export styles, commit message conventions, and how to write and run tests in this repository. This guide is ideal for contributors who want to maintain consistency and follow best practices in `schnapp-kit`.

## Coding Conventions

### File Naming
- **Style:** kebab-case
- **Example:**  
  ```
  user-profile.ts
  data-fetcher.test.ts
  ```

### Import Style
- **Style:** Relative imports
- **Example:**  
  ```typescript
  import { fetchData } from './data-fetcher';
  ```

### Export Style
- **Style:** Named exports
- **Example:**  
  ```typescript
  // In user-profile.ts
  export function getUserProfile(id: string) { ... }
  ```

### Commit Messages
- **Type:** Conventional commits
- **Prefix Example:**  
  ```
  docs: update README with installation instructions
  ```
- **Average Length:** ~86 characters

## Workflows

### Writing Documentation
**Trigger:** When updating or adding documentation files.
**Command:** `/write-docs`

1. Use the `docs:` prefix in your commit message.
2. Update or create markdown files as needed.
3. Follow kebab-case for file names (e.g., `getting-started.md`).
4. Commit your changes with a descriptive message.

### Adding or Modifying Code
**Trigger:** When implementing new features or fixing bugs.
**Command:** `/update-code`

1. Create or update `.ts` files using kebab-case naming.
2. Use relative imports for dependencies within the project.
3. Export functions or variables using named exports.
4. Write clear, conventional commit messages describing your changes.

### Writing and Running Tests
**Trigger:** When adding or updating tests for your code.
**Command:** `/run-tests`

1. Name test files using the pattern `*.test.*` (e.g., `data-fetcher.test.ts`).
2. Place tests alongside the code they test or in a dedicated test directory.
3. Use the project's preferred (currently undetected) testing framework.
4. Run tests using the appropriate command for the chosen framework.

## Testing Patterns

- **Test File Naming:** Use `*.test.*` (e.g., `utils.test.ts`).
- **Framework:** Not explicitly detected; follow existing patterns or consult maintainers.
- **Placement:** Tests are typically located near the code they test or in a `tests` directory.
- **Example:**
  ```typescript
  // data-fetcher.test.ts
  import { fetchData } from './data-fetcher';

  test('fetchData returns expected data', () => {
    // test implementation
  });
  ```

## Commands
| Command        | Purpose                                      |
|----------------|----------------------------------------------|
| /write-docs    | Start a documentation update workflow        |
| /update-code   | Begin a code addition or modification workflow|
| /run-tests     | Run the project's test suite                 |
```
