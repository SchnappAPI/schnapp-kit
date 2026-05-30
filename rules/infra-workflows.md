---
paths:
  - ".github/workflows/**"
  - "**/*.yml"
  - "**/Dockerfile"
---

# Infrastructure / GitHub Actions conventions

## GitHub Actions

- **Self-hosted runner** (`runs-on: [self-hosted, <runner-label>]`) for any workflow that touches a local database, a local service, or project-specific dependencies. `ubuntu-latest` only for pure-CI workflows that need no local resources.
- **Secrets via secrets manager**, not direct GitHub repo secrets. Recommended: `1password/load-secrets-action@v2` with `op://` URIs. Each workflow declares the URIs it needs in the action's `env:` block. The canonical env-var → URI mapping is `.env.template` at repo root. The only allowed direct `secrets.*` references are the secrets manager bootstrap token and `GITHUB_TOKEN`.
- **`workflow_dispatch` (manual trigger)** is the default for any cost-bearing or destructive run. Add a schedule only when cadence is well-understood and the run is idempotent.
- **Workflows that commit and push** must set `git config --local core.hooksPath .githooks` before the first git operation so commit hooks fire the same way as in Claude Code sessions.
- **One-shot migrations** belong only as long as they have a purpose. Delete after they ship.
- **Workflow status:** use `gh run list` for live status. Cached/stale status endpoints return old data.
- Any workflow writing data the UI displays should record a run timestamp to a status table as the LAST step so freshness indicators stay accurate.

## 1Password / secrets manager

- `.env.template` at repo root is the canonical env-var → `op://` URI mapping.
- Local dev: `op run --env-file=.env.template -- <command>` (or equivalent).
- Adding a new env var is a three-part coupled change: vault item/field + `.env.template` entry + code reading the var. A PR missing any part is incomplete.

## Docker

- Pin base image tags. `FROM python:3.12-slim` is acceptable; `FROM python:latest` is not.
- Health checks required for any service container that other containers depend on.
