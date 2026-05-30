---
name: large-scale-artifact-pruning
description: Workflow command scaffold for large-scale-artifact-pruning in schnapp-kit.
allowed_tools: ["Bash", "Read", "Write", "Grep", "Glob"]
---

# /large-scale-artifact-pruning

Use this workflow when working on **large-scale-artifact-pruning** in `schnapp-kit`.

## Goal

Bulk removal of files belonging to a deprecated or unsupported feature, language, or integration (e.g., non-English docs, editor configs, language-specific skills/agents, internal docs, plugins, root scaffolding).

## Common Files

- `core/docs/**`
- `core/.agents/**`
- `core/.cursor/**`
- `core/.kiro/**`
- `core/.opencode/**`
- `core/.github/**`

## Suggested Sequence

1. Understand the current state and failure mode before editing.
2. Make the smallest coherent change that satisfies the workflow goal.
3. Run the most relevant verification for touched files.
4. Summarize what changed and what still needs review.

## Typical Commit Signals

- Identify all files related to the deprecated feature/language/integration (using directory and filename patterns).
- Remove these files in a single commit, grouped by logical section (e.g., docs, configs, skills, plugins, root files).
- Update cleanup tracking files (e.g., docs/cleanup/STATUS.md, docs/cleanup/ledger.tsv) to record the removal.
- Repeat for each logical section as needed.

## Notes

- Treat this as a scaffold, not a hard-coded script.
- Update the command if the workflow evolves materially.