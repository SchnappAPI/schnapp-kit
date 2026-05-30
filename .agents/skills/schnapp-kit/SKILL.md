```markdown
# schnapp-kit Development Patterns

> Auto-generated skill from repository analysis

## Overview
This skill teaches the core development conventions and workflows used in the `schnapp-kit` TypeScript codebase. It covers file organization, code style, commit practices, and testing patterns to help you contribute effectively and maintain consistency across the project.

## Coding Conventions

### File Naming
- Use **kebab-case** for all file names.
  - Example:  
    ```
    my-component.ts
    utils-helper.ts
    ```

### Import Style
- Use **relative imports** for referencing other modules within the project.
  - Example:
    ```typescript
    import { myFunction } from './utils-helper';
    ```

### Export Style
- Use **named exports** rather than default exports.
  - Example:
    ```typescript
    // utils-helper.ts
    export function myFunction() { /* ... */ }
    ```

### Commit Messages
- Follow **conventional commit** standards.
- Use prefixes such as `docs`, `refactor`, etc.
- Keep commit messages concise (average ~70 characters).
  - Example:
    ```
    docs: update README with installation instructions
    refactor: simplify state management logic
    ```

## Workflows

### Refactoring Code
**Trigger:** When improving code structure or readability without changing functionality  
**Command:** `/refactor`

1. Identify code that can be improved (e.g., simplify logic, rename variables).
2. Make changes while ensuring no behavior is altered.
3. Update related documentation if necessary.
4. Commit with a message prefixed by `refactor:`.
5. Run tests to confirm nothing is broken.

### Updating Documentation
**Trigger:** When adding or updating documentation files  
**Command:** `/docs-update`

1. Edit or create documentation files as needed.
2. Ensure clarity and consistency in documentation.
3. Commit changes with a message prefixed by `docs:`.
4. Review for accuracy and completeness.

## Testing Patterns

- Test files follow the pattern: `*.test.*` (e.g., `my-component.test.ts`).
- The testing framework is **unknown** (not detected), but tests should be colocated with the code or in a dedicated `tests` directory.
- Example test file:
  ```typescript
  // my-component.test.ts
  import { myFunction } from './my-component';

  describe('myFunction', () => {
    it('should return true when input is valid', () => {
      expect(myFunction('valid')).toBe(true);
    });
  });
  ```

## Commands

| Command        | Purpose                                         |
|----------------|-------------------------------------------------|
| /refactor      | Refactor code for readability or structure      |
| /docs-update   | Add or update documentation                     |
```
