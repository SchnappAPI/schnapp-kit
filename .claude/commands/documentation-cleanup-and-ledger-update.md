---
name: documentation-cleanup-and-ledger-update
description: Workflow command scaffold for documentation-cleanup-and-ledger-update in schnapp-kit.
allowed_tools: ["Bash", "Read", "Write", "Grep", "Glob"]
---

# /documentation-cleanup-and-ledger-update

Use this workflow when working on **documentation-cleanup-and-ledger-update** in `schnapp-kit`.

## Goal

Removes a set of documentation or configuration files (by topic/section/language/editor) and updates cleanup status and decision ledger.

## Common Files

- `core/docs/*`
- `core/.*/**`
- `docs/cleanup/STATUS.md`
- `docs/cleanup/ledger.tsv`

## Suggested Sequence

1. Understand the current state and failure mode before editing.
2. Make the smallest coherent change that satisfies the workflow goal.
3. Run the most relevant verification for touched files.
4. Summarize what changed and what still needs review.

## Typical Commit Signals

- Identify a group of files to remove (by section, language, or editor).
- Delete all files in the identified group.
- Update docs/cleanup/STATUS.md to reflect the removal.
- Update docs/cleanup/ledger.tsv to record decisions and removals.

## Notes

- Treat this as a scaffold, not a hard-coded script.
- Update the command if the workflow evolves materially.