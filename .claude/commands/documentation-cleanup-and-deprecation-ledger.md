---
name: documentation-cleanup-and-deprecation-ledger
description: Workflow command scaffold for documentation-cleanup-and-deprecation-ledger in schnapp-kit.
allowed_tools: ["Bash", "Read", "Write", "Grep", "Glob"]
---

# /documentation-cleanup-and-deprecation-ledger

Use this workflow when working on **documentation-cleanup-and-deprecation-ledger** in `schnapp-kit`.

## Goal

Removes large groups of obsolete or out-of-scope documentation files and records the changes in a cleanup ledger and status tracker.

## Common Files

- `docs/cleanup/ledger.tsv`
- `docs/cleanup/STATUS.md`
- `docs/cleanup/PLAN.md`
- `core/docs/**`
- `core/.github/**`
- `core/.claude/**`

## Suggested Sequence

1. Understand the current state and failure mode before editing.
2. Make the smallest coherent change that satisfies the workflow goal.
3. Run the most relevant verification for touched files.
4. Summarize what changed and what still needs review.

## Typical Commit Signals

- Identify obsolete, redundant, or out-of-scope documentation files (e.g., migration guides, translations, internal docs, release notes).
- Remove these files from the repository.
- Update docs/cleanup/ledger.tsv to record what was removed and why.
- Update docs/cleanup/STATUS.md to reflect current cleanup progress.

## Notes

- Treat this as a scaffold, not a hard-coded script.
- Update the command if the workflow evolves materially.