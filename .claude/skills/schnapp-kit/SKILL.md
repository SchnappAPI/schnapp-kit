```markdown
# schnapp-kit Development Patterns

> Auto-generated skill from repository analysis

## Overview

This skill documents the core development patterns, coding conventions, and maintenance workflows for the `schnapp-kit` JavaScript codebase. It outlines how to structure code, manage documentation and platform support, and maintain repository hygiene through standardized, repeatable processes. The repository emphasizes clarity, modularity, and active cleanup of obsolete artifacts, with a focus on supporting the Claude Code platform.

## Coding Conventions

### File Naming

- Use **kebab-case** for all file names.
  - Example: `my-component.js`, `utils/helpers.js`

### Import Style

- Use **relative imports** for modules within the repository.
  ```js
  import { doThing } from './utils/do-thing.js';
  ```

### Export Style

- Use **named exports** for all modules.
  ```js
  // utils/do-thing.js
  export function doThing() { ... }
  ```

### Commit Messages

- Follow **Conventional Commits** style.
- Common prefixes: `refactor:`, `docs:`
- Example:
  ```
  refactor: simplify input validation in user-form.js
  docs: update migration guide for v2.0 removal
  ```

## Workflows

### Documentation Cleanup and Deprecation Ledger

**Trigger:** When deprecating, consolidating, or cleaning up documentation and related artifacts.  
**Command:** `/cleanup-docs`

1. Identify obsolete, redundant, or out-of-scope documentation files (such as migration guides, translations, internal docs, release notes).
2. Remove these files from the repository.
3. Update `docs/cleanup/ledger.tsv` to record what was removed and why.
4. Update `docs/cleanup/STATUS.md` to reflect current cleanup progress.

**Files Involved:**
- `docs/cleanup/ledger.tsv`
- `docs/cleanup/STATUS.md`
- `docs/cleanup/PLAN.md`
- `core/docs/**`
- `core/.github/**`
- `core/.claude/**`
- `core/.agents/**`
- `core/.cursor/**`
- `core/.kiro/**`
- `core/.opencode/**`
- `core/agents/**`
- `core/commands/**`
- `core/rules/**`
- `core/skills/**`

---

### Removal of Non-Primary Platform Artifacts

**Trigger:** When support for a platform, editor, or language is dropped or consolidated.  
**Command:** `/prune-platform`

1. Identify files related to deprecated platforms, editors, or languages (such as `.kiro`, `.cursor`, `.opencode`, `.agents`, `.codebuddy`, `.codex`, `.zed`, `.gemini`, `.qwen`, and language-specific agents/skills/rules).
2. Remove these files from the repository.
3. Update `docs/cleanup/ledger.tsv` and `docs/cleanup/STATUS.md` to log the removals.

**Files Involved:**
- `core/.cursor/**`
- `core/.kiro/**`
- `core/.opencode/**`
- `core/.agents/**`
- `core/.codebuddy/**`
- `core/.codex/**`
- `core/.codex-plugin/**`
- `core/.trae/**`
- `core/.zed/**`
- `core/.gemini/**`
- `core/.qwen/**`
- `core/agents/*-reviewer.md`
- `core/commands/*-build.md`
- `core/commands/*-test.md`
- `core/commands/*-review.md`
- `core/rules/golang/**`
- `core/rules/arkts/**`
- `core/rules/zh/**`
- `core/skills/*-testing/SKILL.md`
- `core/skills/*-patterns/SKILL.md`
- `docs/cleanup/ledger.tsv`
- `docs/cleanup/STATUS.md`

---

### CI and Meta Config Cleanup

**Trigger:** When CI/CD or project meta configuration needs to be updated or removed due to project scope changes.  
**Command:** `/cleanup-meta`

1. Identify CI workflows, CODEOWNERS, FUNDING, dependabot, PR/issue templates, and related meta files.
2. Remove these files from the repository.
3. Update `docs/cleanup/ledger.tsv` and `docs/cleanup/STATUS.md` to record the changes.

**Files Involved:**
- `core/.github/**`
- `core/.claude/**`
- `docs/cleanup/ledger.tsv`
- `docs/cleanup/STATUS.md`

---

## Testing Patterns

- Test files follow the pattern: `*.test.*`
  - Example: `math-utils.test.js`
- The specific testing framework is not documented; check existing test files for conventions.
- Place tests alongside or near the modules they test, using the same kebab-case naming.

## Commands

| Command         | Purpose                                                                 |
|-----------------|-------------------------------------------------------------------------|
| /cleanup-docs   | Remove obsolete documentation and update the cleanup ledger and status.  |
| /prune-platform | Remove files for unsupported platforms/languages and log the removals.   |
| /cleanup-meta   | Remove CI/meta configuration files and update cleanup records.           |
```
