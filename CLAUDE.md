# CLAUDE.md — schnapp-kit

A personal Claude Code distribution. The kit is layered: `core/` (ECC fork) → `vendored/*/` (community plugins) → `language-packs/*/` (per-language opt-ins) → `overlays/` (schnapp-bet promotions and net-new).

## Working on the kit

- **Layer respect** — never edit files inside `core/` or `vendored/<plugin>/` directly. Those are sync'd from upstream. To override, add a same-named file in `overlays/overrides/` (it shadows by filename).
- **`kit.config.yml` is the steering wheel** — toggle artifacts via glob patterns under `enabled_artifacts` / `disabled_artifacts`. After any edit, run `scripts/conflict-check.sh`.
- **Re-syncing upstreams** is one command: `scripts/sync-upstream.sh <name>` for one or `scripts/sync-upstream.sh --all`. Conflicts surface as test failures.
- **Adding a new community plugin** — `scripts/add-upstream.sh <name> <github-url> <pin>`. See `docs/ADDING-A-PLUGIN.md`.
- **Adding a new language pack** — see `docs/ADDING-A-LANGUAGE.md`.

## ADRs

`docs/decisions/ADR-YYYYMMDD-N-slug.md`. Same date-counter format as schnapp-bet.

## Commit format

```
<type>: [scope1][scope2] short description — ADR-YYYYMMDD-N
```

Scopes for this repo: `[core]`, `[vendored]`, `[overlays]`, `[lang]`, `[scripts]`, `[docs]`, `[tests]`, `[meta]`, `[all]`.

## Branch workflow

All changes go on feature branches (`feat/<short-description>`). Direct commits to `main` are blocked by a PreToolUse hook. After committing, a PR is auto-created. After work is complete with a clean working tree, the Stop hook auto-merges the PR and deletes the branch.

## Skills the kit ships for evolving itself

- `/discover-kit-additions <repo-url> [--focus <path>]` — scan a repo for artifacts schnapp-kit doesn't have yet.
- `/audit-against-kit <repo-url-or-path>` — scan a project repo for delta vs the kit (uncovered conventions, promotion candidates, duplicates, conflicts).
- `/promote-from-project` — move a project-local artifact into `overlays/`.
- `/vendor-plugin <url>` — wrapper around `scripts/add-upstream.sh`.
- `/sync-upstreams` — bump pins and re-test.
