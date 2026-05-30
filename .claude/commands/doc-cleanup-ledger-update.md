---
name: doc-cleanup-ledger-update
description: Workflow command scaffold for doc-cleanup-ledger-update in schnapp-kit.
allowed_tools: ["Bash", "Read", "Write", "Grep", "Glob"]
---

# /doc-cleanup-ledger-update

Use this workflow when working on **doc-cleanup-ledger-update** in `schnapp-kit`.

## Goal

Tracks and records documentation or artifact cleanup actions, updating both status and decision ledger files for traceability.

## Common Files

- `docs/cleanup/STATUS.md`
- `docs/cleanup/ledger.tsv`

## Suggested Sequence

1. Understand the current state and failure mode before editing.
2. Make the smallest coherent change that satisfies the workflow goal.
3. Run the most relevant verification for touched files.
4. Summarize what changed and what still needs review.

## Typical Commit Signals

- Remove or modify a set of documentation or artifact files (e.g., guides, translations, config mirrors, internal docs, plugins, language artifacts).
- Update docs/cleanup/STATUS.md to reflect current cleanup status.
- Update docs/cleanup/ledger.tsv to log decisions and actions taken.

## Notes

- Treat this as a scaffold, not a hard-coded script.
- Update the command if the workflow evolves materially.