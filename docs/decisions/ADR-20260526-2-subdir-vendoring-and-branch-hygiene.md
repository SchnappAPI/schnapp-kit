# ADR-20260526-2: Subdir vendoring and automated branch hygiene

**Status**: Accepted
**Date**: 2026-05-26

---

## Decision 1 — Subdir vendoring pattern

### Context

Six plugins from `anthropics/claude-code` live under `plugins/<name>/` inside a monorepo, not as separate repos. The existing `add-upstream.sh` / `sync-upstream.sh` scripts expected a single root URL with all content at `/`, so they would rsync the entire monorepo on every sync.

### Decision

Add an optional `subdir:` field to `.upstreams.yml` entries. When present, `sync-upstream.sh` rsyncs from `<checkout>/<subdir>/` instead of `<checkout>/`. `add-upstream.sh` accepts a fourth positional argument `<subdir>` and writes it into `.upstreams.yml`.

```yaml
# .upstreams.yml example
anthropics-claude-code-clean-gone:
  url: https://github.com/anthropics/claude-code
  pin: <sha>
  subdir: plugins/clean-gone
```

### Consequences

- Six anthropics plugins vendorable from a single upstream entry each, without forking the monorepo.
- Scripts remain backward-compatible: entries without `subdir:` behave identically to before.
- Pin granularity is per-repo (monorepo commit), not per-plugin — a single monorepo bump updates all plugins from that repo simultaneously.

### Alternatives considered

- **Fork each plugin into its own repo** — Rejected. Maintenance overhead; no control over the upstream fork list.
- **Vendor the entire monorepo** — Rejected. Pulls in thousands of unrelated files on every sync.

---

## Decision 2 — Automated branch hygiene via Claude Code hooks

### Context

Direct commits to `main` and stale feature branches were causing session drift: Claude would start a new session on an old branch, or make commits directly to main, making the git history hard to follow and upstreams hard to sync cleanly.

### Decision

Four Claude Code hooks enforce the feature-branch workflow automatically, requiring no human memory:

| Hook event | Script | Behavior |
|---|---|---|
| `PreToolUse(Bash)` | `no-commit-to-main.sh` | Exits 2 (blocking) if `git commit` or `git merge` runs on `main`/`master` |
| `PostToolUse(Bash)` | `auto-pr-after-commit.sh` | After `git commit` on a feature branch, pushes to remote and opens a PR via `gh pr create --fill` (async, non-blocking) |
| `Stop` | `auto-merge-on-stop.sh` | When Claude finishes a response and the working tree is clean, squash-merges the open PR and deletes the branch (asyncRewake — rewakes Claude to report the result) |
| `SessionStart` | `session-start-git-context.sh` | Injects current branch name, commit count ahead of main, and open PR list into Claude's context via `additionalContext` |

All scripts live in `overlays/hooks/claude/`; wiring is in `overlays/hooks/hooks.json`.

### Consequences

- Branches stay short-lived: commit → auto-PR → clean stop → auto-merge, all without user input.
- Claude is always aware of branch state at session start, preventing accidental cross-branch work.
- The PreToolUse block is the safety net: even if a user or Claude tries to commit to main, the hook rejects it before git runs.
- `auto-pr-after-commit.sh` pushes the branch itself (no separate git post-commit hook needed).

### Alternatives considered

- **Git hooks (`.git/hooks/`)** — Rejected for the main guard. Git hooks are local-only and not committed; Claude Code hooks live in the repo and apply consistently across machines.
- **Branch protection rules on GitHub** — Useful complementary layer but doesn't prevent Claude from *trying*; the PreToolUse hook catches it client-side before any network call.
- **Manual PR creation** — Rejected. Relying on human memory means branches accumulate.
