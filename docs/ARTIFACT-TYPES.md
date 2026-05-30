# Artifact Types

schnapp-kit organizes artifacts by type. Each type has a canonical location within each layer.

## Agents (`agents/*.md`)

Specialized Claude Code subagents with focused capabilities and a specific tool allowlist. Frontmatter fields: `name`, `description`, `tools`.

Examples: `secrets-hygiene-reviewer`, `etl-integrity-reviewer`, `code-reviewer`.

## Skills (`skills/<name>/SKILL.md`)

Prompt-driven procedures Claude invokes for multi-step workflows. Each skill lives in its own directory so it can bundle reference files alongside `SKILL.md`. Frontmatter fields: `name`, `description`, optional `when_to_use`.

Examples: `adr-writer`, `workflow`, `discover-kit-additions`, `tdd`.

## Commands (`commands/<name>.md`)

User-invocable slash commands (`/<name>`). Often paired with a skill of the same name. Frontmatter fields: `name`, `description`, optional `disable-model-invocation: true` (for commands that run shell scripts directly).

Examples: `adr`, `status`, `vendor-plugin`.

## Hooks

Two categories:

### Git hooks (`hooks/git/`)

Shell scripts wired via `git config core.hooksPath .githooks`. Run at git lifecycle points.

- `commit-msg` — validate commit subject format.
- `post-commit` — auto-push to origin.

### Claude Code hooks (`hooks/claude/`)

Shell scripts wired in `settings.json` under `hooks:`. Run at Claude Code lifecycle points (`PreToolUse`, `PostToolUse`, `Stop`).

- `destructive-guard.sh` — PreToolUse: block dangerous commands.
- `protect-shipped-adrs.sh` — PreToolUse(Edit|Write): enforce ADR append-only invariant.
- `ruff-lint.sh` — PostToolUse(Edit|Write): auto-lint Python files.
- `stop-reminder.sh` — Stop: safety-net push for missed post-commit pushes.

## Rules (`rules/*.md`)

Auto-loaded markdown files that inject conventions into Claude's context when matching files are edited. Frontmatter `paths:` list controls activation (glob patterns).

Examples: `secrets.md`, `docs.md`, `database.md`, `web.md`.

## Contexts (`contexts/*.md`)

Named context profiles activated via `/mode <name>`. Set Claude's posture for a work session (e.g. `dev`, `review`, `research`). Check `contexts/` before adding new ones.

## Output styles (`output-styles/*.md`)

Templates that control how Claude formats its responses.

## Statuslines (`statuslines/*.md` or config)

Statusline badge configurations for Claude Code's terminal UI. ECC ships examples.

## MCP server configs (`mcp/*.json`)

Model Context Protocol server definitions. Describe tools and resources Claude can access via MCP.

## Workflow templates (`.github/workflows/*.yml`)

Reusable GitHub Actions workflows (using `workflow_call`). Useful for sharing CI patterns across repos.
