# CLAUDE.md — schnapp-kit

A personal Claude Code distribution, shipped as a single flat plugin. Everything
here is **owned** — there is no upstream fork to re-sync, no layers, no config to
toggle. What you see in the tree is what ships.

## Activation — installed vs. just open in the repo

This repo *defines* the plugin; it does not auto-activate by being open. In a
session whose working dir is this repo, only `CLAUDE.md` and
`.claude/settings.json` load. The skills, agents, commands, and **hooks are inert
until the kit is installed/enabled as a plugin**
(`/plugin install github:schnappapi/schnapp-kit`). So the branch-workflow and
guard behaviors described below apply **only when the plugin is installed** —
don't assume `main` is protected or that PRs auto-create in a bare repo session.

The repo-local git hooks (`.githooks/commit-msg`, `post-commit`) are also off by
default; activate them once per clone:

```
git config core.hooksPath .githooks
```

See `docs/CATALOG.md` for the full inventory of what ships, and `ROADMAP.md` for
current focus.

## Layout

```
skills/      — agent skills (one dir per skill, with SKILL.md + any references/scripts)
agents/      — subagent definitions (one .md each)
commands/    — slash commands (one .md each)
rules/       — coding/convention rules (referenced by skills + CLAUDE.md, not auto-loaded)
contexts/    — reusable context blocks
hooks/       — hook scripts + the single merged hooks/hooks.json
docs/        — architecture notes, ADRs, guides
tests/       — repo validation scripts
.claude-plugin/plugin.json — plugin manifest (standard flat discovery)
```

## Working on the kit

- **Own everything** — edit any artifact in place. There is no "don't touch core"
  rule anymore; nothing is vendored or synced.
- **Adding an artifact** — drop it in the matching top-level dir (`skills/<name>/SKILL.md`,
  `agents/<name>.md`, `commands/<name>.md`). It's discovered automatically.
- **Hooks** — all hooks live in `hooks/` and are wired through the single
  `hooks/hooks.json`. Command paths use `${CLAUDE_PLUGIN_ROOT}/hooks/...`.
- **Attribution** — third-party artifacts (mattpocock, plugin-dev, ralph-wiggum,
  agent-sdk-dev, security-guidance, ECC) are recorded in `ATTRIBUTION.md`. Keep it
  current when adding outside material.

## ADRs

`docs/decisions/ADR-YYYYMMDD-N-slug.md`. Same date-counter format as schnapp-bet.

## Commit format

```
<type>: [scope1][scope2] short description — ADR-YYYYMMDD-N
```

Scopes for this repo: `[skills]`, `[agents]`, `[commands]`, `[rules]`, `[contexts]`, `[hooks]`, `[docs]`, `[tests]`, `[meta]`, `[all]`.

## Branch workflow

All changes go on feature branches (`feat/<short-description>`). **When the kit is installed as a plugin**, direct commits to `main` are blocked by a PreToolUse hook, a PR is auto-created after the commit, and the Stop hook auto-merges the PR and deletes the branch once the tree is clean. In a bare repo session these guards are **not** active — follow the workflow manually (branch, push with `-u`, open the PR).

## Task scope discipline

Before editing any file, confirm it falls within the current task's scope:
1. Files already modified in the current branch (`git diff main...HEAD --name-only`)
2. New files being created as part of the current task
3. Files explicitly named in the user's request

**Always re-read a file immediately before editing it** — never edit from memory of a prior read. If you need to edit a file outside the above scope, state why before proceeding. Do not make opportunistic edits to unrelated files.
