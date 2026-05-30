---
name: discover-kit-additions
description: Scan an arbitrary GitHub repo (or local path) and surface artifacts schnapp-kit doesn't yet have. Use when the user says "review this repo for kit additions", "what should I take from <repo>", "scan <url> for useful skills/agents/hooks", or `/discover-kit-additions <url>`. Supports `--focus <subpath>` to narrow the scan to one area of a large repo.
---

# discover-kit-additions

Discovery pass over a candidate repo, producing a ranked list of artifacts worth absorbing into schnapp-kit.

## When to use

- User invokes `/discover-kit-additions <repo-url>` or `/discover-kit-additions <repo-url> --focus <subpath>`.
- User asks "what should I take from <repo>", "scan <repo> for useful agents/skills/hooks/commands", "review this for kit additions".
- After cloning a starred repo you keep meaning to mine.

## Inputs

- **`<repo-url>`** (required) — GitHub URL or local path.
- **`--focus <path>`** (optional) — restrict scan to one subpath, e.g. `--focus skills/engineering`. Without it, scan all known artifact directories.

## Procedure

1. **Resolve source.** If URL, `gh repo clone` (or read via GitHub MCP if network-restricted) into a temp dir. Capture commit sha for later pinning.
2. **Enumerate kit state.** Build a set of artifact names already in schnapp-kit by walking `core/`, `vendored/*/`, `overlays/`, `language-packs/*/`. Index by canonical name (last path segment, lowercased).
3. **Enumerate candidate artifacts.** In the source repo, scan for:
   - `agents/*.md` or `**/agents/*.md`
   - `skills/**/SKILL.md`
   - `commands/*.md` or `**/commands/*.md`
   - `hooks/*` (executable scripts)
   - `rules/*.md` or `.cursor/rules/`, `.cursorrules`, `CLAUDE.md`, `AGENTS.md`
   - `.mcp.json` / `mcp-servers/`
   - `output-styles/`, `statuslines/`
   - Workflow templates: `.github/workflows/*.yml` that look reusable (`workflow_call`)
   - Plugin manifests: `.claude-plugin/plugin.json`
4. **Diff.** For each candidate, decide:
   - Already in kit → skip (unless `--show-duplicates` flag).
   - Net-new → candidate.
5. **Classify each candidate** with:
   - **Type** (agent / skill / command / hook / rule / mcp / workflow / output-style / statusline).
   - **Source path** (with permalink to pinned ref if URL source).
   - **One-line description** (from frontmatter `description:` or first non-frontmatter line).
   - **Gap filled** — what kit-side weakness this addresses.
   - **Recommendation**: `vendor` (third-party upstream → `vendored/<source-name>/`) or `promote` (your own work / public-domain pattern → `overlays/`).
   - **Draft `kit.config.yml` block** — a copy-pasteable snippet that wires the candidate in.
   - **Conflicts** — any same-name artifacts already in the kit (forces a shadow or rename decision).
6. **Rank.** Within each type, order by likely-utility (frontmatter quality + description specificity + presence of bundled examples).
7. **Output a structured markdown report** with sections per artifact type. End with a "Next actions" block listing exact `/vendor-plugin` or `/promote-from-project` commands.

## Output format

````markdown
# Discovery report — <source-repo> @ <sha>

Scope: <full|--focus subpath>
Candidates: <N>
Recommendation summary: <X to vendor, Y to promote, Z conflicts>

## Skills (M candidates)

| Name | Path | Description | Gap filled | Action | Conflicts |
| ---- | ---- | ----------- | ---------- | ------ | --------- |
| ...  |      |             |            |        |           |

## Agents (M candidates)

...

## Hooks (M candidates)

...

## Next actions

```bash
# Vendor the whole upstream:
/vendor-plugin <source-repo-url> --pin <sha>

# Enable specific cherry-picks (paste into kit.config.yml):
- skills/foo/**
- agents/bar.md

# OR, for individual promotions:
/promote-from-project <source-path> --type skill --name foo
```
````

```

## Failure modes to handle

- Source repo too large to scan in one pass → recommend `--focus <path>` and exit.
- No `.claude-plugin/plugin.json` and no recognizable artifact directories → emit "no artifacts detected; this repo is probably not a Claude Code distribution" and exit.
- Network unreachable for clone → ask the user for the relevant subpaths and proceed manually.

## Composes with

- `/vendor-plugin <url>` — executes vendor recommendations.
- `/promote-from-project <path>` — executes promote recommendations.
- `/audit-against-kit <repo>` — the inverse direction (does the kit cover this repo).
```
