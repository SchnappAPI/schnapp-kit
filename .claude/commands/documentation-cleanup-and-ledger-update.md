---
name: documentation-cleanup-and-ledger-update
description: Workflow command scaffold for documentation-cleanup-and-ledger-update in schnapp-kit.
allowed_tools: ["Bash", "Read", "Write", "Grep", "Glob"]
---

# /documentation-cleanup-and-ledger-update

Use this workflow when working on **documentation-cleanup-and-ledger-update** in `schnapp-kit`.

## Goal

Removes obsolete or unnecessary documentation files and records the changes and decisions in a cleanup ledger and status tracker.

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

- Identify documentation files to remove (e.g., adapter guides, localized docs).
- Delete the identified files from their respective directories.
- Update or create entries in docs/cleanup/ledger.tsv to record what was removed and why.
- Update docs/cleanup/STATUS.md to reflect current cleanup status.
- Optionally, update docs/cleanup/PLAN.md with future cleanup intentions.

## Notes

- Treat this as a scaffold, not a hard-coded script.
- Update the command if the workflow evolves materially.