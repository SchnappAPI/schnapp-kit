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
- `hooks/` — branch-workflow, scope/destructive guards, and security-review hooks

**Curation**: built down from ~3,000 files to a focused set scoped to a
Python + TypeScript + SQL + infra stack. See `docs/cleanup/MANIFEST.md` for the
full keep/cut record and `docs/decisions/` for the architecture ADRs.
