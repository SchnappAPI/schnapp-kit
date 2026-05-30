```markdown
# schnapp-kit Development Patterns

> Auto-generated skill from repository analysis

## Overview
This skill documents the development and maintenance patterns for the `schnapp-kit` JavaScript codebase. It covers coding conventions, cleanup and documentation workflows, and testing practices. The repository emphasizes maintainability, traceability, and consistent structure, especially when removing or refactoring documentation and editor configuration files.

## Coding Conventions

### File Naming
- Use **camelCase** for file names.
  - Example: `myUtilityFunction.js`, `userProfileHandler.js`

### Import Style
- Use **relative imports** for modules within the codebase.
  ```js
  import { fetchData } from './apiUtils.js';
  ```

### Export Style
- Use **named exports**.
  ```js
  // In utils.js
  export function calculateSum(a, b) {
    return a + b;
  }

  // In another file
  import { calculateSum } from './utils.js';
  ```

### Commit Messages
- Follow **conventional commit** patterns.
- Common prefixes: `refactor`, `docs`
- Example:
  ```
  refactor: simplify data fetching logic in userProfileHandler.js
  docs: update API usage section in README
  ```

## Workflows

### Documentation Section Removal
**Trigger:** When deprecating or removing support for a tool, language, or localization, or cleaning up unused documentation.  
**Command:** `/remove-doc-section`

1. Identify documentation files to remove (e.g., guides, translations, config docs) under a specific directory or language.
2. Delete the relevant files and folders.
3. Update or create entries in `docs/cleanup/ledger.tsv` to record the decision.
4. Update `docs/cleanup/STATUS.md` or `docs/cleanup/PLAN.md` to reflect the change.

**Example:**
```bash
# Remove French documentation
rm -rf core/docs/fr/
# Record the removal in the ledger
echo -e "2024-06-10\tRemoved French docs\tOutdated translation" >> docs/cleanup/ledger.tsv
# Update status
echo "- [x] French docs removed" >> docs/cleanup/STATUS.md
```

---

### Editor Config Mirror Removal
**Trigger:** When dropping support for non-primary editors or platforms and cleaning up legacy config mirrors.  
**Command:** `/remove-editor-mirrors`

1. Identify config/skill files under editor-specific directories (e.g., `.cursor`, `.kiro`, `.opencode`, etc.).
2. Delete all files and folders under these directories.
3. Update `docs/cleanup/ledger.tsv` and `docs/cleanup/STATUS.md` to record the removal.

**Example:**
```bash
# Remove all mirrored editor configs
rm -rf core/.cursor/ core/.kiro/ core/.opencode/ core/.agents/ core/.codebuddy/ core/.codex/ core/.codex-plugin/ core/.zed/ core/.gemini/ core/.qwen/
# Log the cleanup
echo -e "2024-06-10\tRemoved editor config mirrors\tNo longer supported" >> docs/cleanup/ledger.tsv
echo "- [x] Editor config mirrors cleaned" >> docs/cleanup/STATUS.md
```

---

### Cleanup Ledger Update
**Trigger:** When making any significant removal, refactor, or documentation change that should be tracked for future reference.  
**Command:** `/update-cleanup-ledger`

1. Make the code or documentation changes (e.g., remove files, refactor sections).
2. Add or update an entry in `docs/cleanup/ledger.tsv` describing the change and rationale.
3. Update `docs/cleanup/STATUS.md` and/or `docs/cleanup/PLAN.md` as needed.

**Example:**
```bash
# After refactoring a module
echo -e "2024-06-10\tRefactored userProfileHandler.js\tImproved maintainability" >> docs/cleanup/ledger.tsv
echo "- [x] userProfileHandler.js refactored" >> docs/cleanup/STATUS.md
```

## Testing Patterns

- Test files follow the pattern: `*.test.*`
- Testing framework is **unknown**; check for files like `myModule.test.js`
- Example test file:
  ```js
  // userProfileHandler.test.js
  import { getUserProfile } from './userProfileHandler.js';

  test('returns correct user profile', () => {
    const result = getUserProfile('alice');
    expect(result.name).toBe('Alice');
  });
  ```

## Commands

| Command                | Purpose                                                      |
|------------------------|--------------------------------------------------------------|
| /remove-doc-section    | Remove a whole documentation section and update cleanup logs |
| /remove-editor-mirrors | Remove editor config mirrors and update cleanup logs         |
| /update-cleanup-ledger | Record and track major cleanup or refactor changes           |
```
