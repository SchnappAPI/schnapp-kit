---
name: documentation-section-removal
description: Workflow command scaffold for documentation-section-removal in schnapp-kit.
allowed_tools: ["Bash", "Read", "Write", "Grep", "Glob"]
---

# /documentation-section-removal

Use this workflow when working on **documentation-section-removal** in `schnapp-kit`.

## Goal

Removes a whole section or category of documentation or guides, often as part of a cleanup or refactor, and records the change in a cleanup ledger.

## Common Files

- `core/docs/*`
- `docs/cleanup/ledger.tsv`
- `docs/cleanup/STATUS.md`
- `docs/cleanup/PLAN.md`

## Suggested Sequence

1. Understand the current state and failure mode before editing.
2. Make the smallest coherent change that satisfies the workflow goal.
3. Run the most relevant verification for touched files.
4. Summarize what changed and what still needs review.

## Typical Commit Signals

- Identify documentation files to remove (e.g., guides, translations, config docs) under a specific directory or language.
- Delete the relevant files and folders.
- Update or create entries in docs/cleanup/ledger.tsv to record the decision.
- Update docs/cleanup/STATUS.md or PLAN.md to reflect the change.

## Notes

- Treat this as a scaffold, not a hard-coded script.
- Update the command if the workflow evolves materially.