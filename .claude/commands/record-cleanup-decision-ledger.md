---
name: record-cleanup-decision-ledger
description: Workflow command scaffold for record-cleanup-decision-ledger in schnapp-kit.
allowed_tools: ["Bash", "Read", "Write", "Grep", "Glob"]
---

# /record-cleanup-decision-ledger

Use this workflow when working on **record-cleanup-decision-ledger** in `schnapp-kit`.

## Goal

Tracks and documents major codebase cleanup decisions and status.

## Common Files

- `docs/cleanup/ledger.tsv`
- `docs/cleanup/STATUS.md`

## Suggested Sequence

1. Understand the current state and failure mode before editing.
2. Make the smallest coherent change that satisfies the workflow goal.
3. Run the most relevant verification for touched files.
4. Summarize what changed and what still needs review.

## Typical Commit Signals

- Edit or remove a large set of files (docs, configs, code, etc.) as part of a cleanup or refactor.
- Update docs/cleanup/ledger.tsv to record the decision and affected files.
- Update docs/cleanup/STATUS.md to reflect the new status of the cleanup effort.

## Notes

- Treat this as a scaffold, not a hard-coded script.
- Update the command if the workflow evolves materially.