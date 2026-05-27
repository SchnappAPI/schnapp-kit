---
description: Universal secrets hygiene policy. Auto-load on any project using schnapp-kit.
---

- **A secrets manager vault is the single source of truth** for runtime secrets. The recommended pattern is 1Password with `op://` URIs in `.env.template`.
- **Bootstrap secret**: one secret per project (e.g. `OP_SERVICE_ACCOUNT_TOKEN` for 1Password) lives in the shell environment. For interactive shells: `~/.zshrc`. For services that need it before any shell sources (e.g. launchd): also export it from `~/.zshenv` and inject it via a login-time env agent (`launchctl setenv` on macOS). CI secrets live as the single repo-level secret. All other secrets are resolved via the secrets manager at runtime.
- **Local dev**: invoke commands via `op run --env-file=.env.template -- <command>` (or equivalent for your secrets manager). Never resolve secret URIs to a plaintext file on disk.
- **CI/CD**: use the secrets manager action (e.g. `1password/load-secrets-action@v2`). Each workflow declares the URIs it needs explicitly. Direct `secrets.*` references in workflow YAML are forbidden except for the bootstrap secret and `GITHUB_TOKEN`.
- **CLI tools with plugin support** (e.g. `gh`): prefer `op plugin run -- <cli>` integration so authentication uses biometric vault unlock rather than a stored token. Source `~/.config/op/plugins.sh` in your shell to activate.
- **Claude Code sessions**: the `env` block in `~/.claude/settings.json` accepts `op://` URIs. Claude Code resolves them natively on session start — no separate `op run` wrapper needed.
- **Adding a new env var** is a coupled three-part change: (1) create the vault item/field, (2) add a `NEW_VAR=op://<vault>/...` line to `.env.template`, (3) add the code that reads `os.environ['NEW_VAR']` or `process.env.NEW_VAR`. A PR with only the code side is incomplete.
- **No plaintext credentials in source control** — ever. Strings that look like API keys, tokens, passwords, or connection strings with embedded credentials are violations even in test fixtures.
- **Hostnames and IPs** are not secrets, but they are environment-specific. Production host values belong in env config, not hardcoded in source.

See `overlays/agents/secrets-hygiene-reviewer.md` for the automated diff-level enforcement agent.
