# schnapp-kit

A personal Claude Code distribution — a curated, flat plugin of skills, agents,
commands, rules, and workflow hooks. Originally assembled from
[affaan-m/ECC](https://github.com/affaan-m/ECC) plus community plugins; now
flattened and owned, with no upstream re-sync.

**Install**: `/plugin install github:schnappapi/schnapp-kit`

**What's inside**:

- `skills/` — agent skills (Python/TypeScript/SQL/infra dev, AI-agent engineering, testing, security, kit meta-tooling)
- `agents/` — subagent definitions (reviewers, architects, resolvers)
- `commands/` — slash commands (planning, PRs, multi-model workflows, instinct learning)
- `rules/` — coding conventions (common + python/typescript/web)
- `contexts/` — reusable context blocks
- `hooks/` — branch-workflow, scope/destructive guards, compaction continuity, session cleanup, and security-review hooks
- `.mcp.json` — opt-in MCP servers (GitHub). Project-scoped, so it stays *pending approval* until you approve it — see [`docs/MCP.md`](docs/MCP.md)

**Catalog**: [`docs/CATALOG.md`](docs/CATALOG.md) is the generated inventory of
every skill, agent, command, hook, and rule. **Note**: the skills/agents/commands/
hooks are active only when the kit is *installed as a plugin* — opening a session
in this repo alone does not load them (see [`CLAUDE.md`](CLAUDE.md) → Activation).

**Developing this repo**: enable the repo-local git hooks once per clone with
`git config core.hooksPath .githooks`, and run `bash tests/run-all.sh` (also run
in CI) before pushing. Regenerate the catalog with `python3 tests/gen-catalog.py`.

**Curation**: built down from ~3,000 files to a focused set scoped to a
Python + TypeScript + SQL + infra stack. See `docs/cleanup/MANIFEST.md` for the
full keep/cut record and `docs/decisions/` for the architecture ADRs.
