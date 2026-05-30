# Roadmap

The standing "what are we doing with the kit" file. A fresh session should read
this (plus `CLAUDE.md`) to pick up current intent — it is direction, not a
binding task. Keep it short; prune done items into the Done list.

## Current focus

- Nothing actively in flight. The kit is flat, owned, validated, and installable.
- Next time you sit down, state the task — this file just keeps the north star.

## Recently done

- **Flatten & own** — collapsed the four-layer ECC fork into one flat plugin
  (~3,000 → ~465 files). See `docs/decisions/ADR-20260530-1-flatten-and-own.md`.
- **Plugin-load smoke test** — `tests/smoke-plugin.sh` reproduces discovery and
  fires the guard hooks for real.
- **MCP + continuity hooks + CI** — `.mcp.json` (GitHub, pending-approval);
  PreCompact → SessionStart → SessionEnd state continuity; GitHub Actions runs
  the validator suite on every PR.
- **Orientation** — Activation section in `CLAUDE.md`, generated
  `docs/CATALOG.md`, and this file.

## Candidates (reviewed, not yet chosen)

- **Slim the 44 heavy skills** — split 300+ line `SKILL.md` files into a lean
  overview + `references/` for lower per-trigger token cost.
- **Command ergonomics** — `allowed-tools` scoping, `!`bash` context injection,
  and `model:` pinning across the 59 commands (most use none of these).
- **Output style + statusline** — neither ships today.
- **More MCP servers** — Cloudflare / M365 / etc. if you want them always-on.

## Manual follow-ups (need the owner)

- None — all caught up.
