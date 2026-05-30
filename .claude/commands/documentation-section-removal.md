---
name: documentation-section-removal
description: Workflow command scaffold for documentation-section-removal in schnapp-kit.
allowed_tools: ["Bash", "Read", "Write", "Grep", "Glob"]
---

# /documentation-section-removal

Use this workflow when working on **documentation-section-removal** in `schnapp-kit`.

## Goal

Removes an entire section or category of documentation files (e.g., guides, translations, internal docs) from the codebase as part of a cleanup or refactor.

## Common Files

- `core/docs/*`
- `core/docs/<lang>/*`
- `core/docs/releases/*`
- `docs/cleanup/ledger.tsv`
- `docs/cleanup/STATUS.md`

## Suggested Sequence

1. Understand the current state and failure mode before editing.
2. Make the smallest coherent change that satisfies the workflow goal.
3. Run the most relevant verification for touched files.
4. Summarize what changed and what still needs review.

## Typical Commit Signals

- Identify all files in the targeted documentation section (e.g., core/docs/ANTIGRAVITY-GUIDE.md, core/docs/ja-JP/*, core/docs/releases/*).
- Delete all files matching the section's pattern.
- Update cleanup tracking files (e.g., docs/cleanup/ledger.tsv, docs/cleanup/STATUS.md) to record the removal.
- Optionally, add or update review aids or index files to reflect the change.

## Notes

- Treat this as a scaffold, not a hard-coded script.
- Update the command if the workflow evolves materially.