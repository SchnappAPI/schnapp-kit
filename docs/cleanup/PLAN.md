# Cleanup & Flatten schnapp-kit — multi-session plan

> Repo-local copy of the approved plan (the canonical one in `~/.claude/plans/`
> does not survive the ephemeral container). `docs/cleanup/STATUS.md` tracks live
> progress; `docs/cleanup/ledger.tsv` holds per-artifact keep/cut decisions.

## Context

`schnapp-kit` is a personal Claude Code distribution that ballooned to **~2,974
tracked files**, of which **2,734 (92%) live in `core/`** — a synced fork of
upstream ECC that is mostly unused. The layered design (`core/` → `vendored/` →
`language-packs/` → `overlays/`, merged by basename shadowing, steered by
`kit.config.yml`) exists mainly to keep that fork re-syncable.

**Decisions locked:**
1. **Flatten & own** — keep only used artifacts in a flat layout; delete the fork
   + sync machinery. Give up upstream ECC re-sync (intended).
2. **Bulk-first, then file-by-file** — bulk-cut dead weight by group with sign-off,
   then grill keep/cut file-by-file on the much smaller survivor set.
3. **Surfaces: CLI + web/Cowork** — cut other-editor mirrors, but keep a
   simplified web/Cowork install path.

## End-state target layout (flat, owned)

```
schnapp-kit/
├── .claude-plugin/plugin.json   # flat layout; no kit.config / discoveryRoots layers
├── agents/  commands/  skills/<name>/SKILL.md  hooks/  rules/
├── docs/    (kept docs + docs/decisions/ ADRs + docs/cleanup/)
├── tests/   (trimmed validators matching the flat layout)
├── scripts/ (only kept scripts; web-install path if retained)
├── CLAUDE.md  README.md
```
Gone: `core/`, `vendored/`, `language-packs/`, `kit.config.yml`,
`vendored/.upstreams.yml`, fork/sync scripts. Kept vendored artifacts copied in
with `ATTRIBUTION.md` (upstream + pinned commit).

## Core technique — read-once decision ledger
`docs/cleanup/ledger.tsv`, written once per decision unit and read many times.
Columns: `path｜type｜group｜purpose｜deps｜size｜decision｜target_path｜notes`.
Bulk-cut groups are recorded at directory level (so ~2,000 files never get
individual rows). A file's content is only opened to (a) drill in, or (b)
copy/rewrite a keeper at flatten time.

## Phases
- **0 Setup** — branch, ledger, STATUS, PLAN copy. ✅
- **1 Bulk cuts** — groups A–F (~2,061 files), group-level sign-off, `git rm -r`.
- **2 Inventory survivors** — scripted frontmatter sweep over remaining
  skills/agents/commands/rules/overlays/lang-packs → ledger rows (name, purpose,
  deps, size).
- **3 File-by-file grilling** — walk `decision=undecided` rows in batches; record
  keep/cut.
- **4 Flatten & reorganize** — move keepers to flat layout; fold lang-pack rules
  & hooks; copy kept vendored artifacts + ATTRIBUTION; rewrite all refs that
  pointed into `core/`/`vendored/`/`overlays/`; rewrite `plugin.json`; delete dead
  layers + `kit.config.yml`; rewrite `CLAUDE.md`/`README.md`.
- **5 Verify** — trim `tests/validate-*.sh`, retire `conflict-check.sh`;
  dangling-reference grep (no paths to deleted dirs); hook smoke test; valid
  `plugin.json`; commit per phase; open PR.

## Dependency guardrails ("removing X affects Y")
Before a **cut**: ledger `deps` shows nothing *kept* references it.
Before a **keep**: its bundled `references/`/`scripts/` and invoked
skills/commands/scripts come along (or get rewritten).
After flatten: the Phase-5 dangling-reference grep is the backstop.

Key known linkages (from dependency map):
- `overlays/hooks/hooks.json` wires 10 claude/* + 2 git/* hooks; flatten must
  repoint `${CLAUDE_PLUGIN_ROOT}/hooks/...` paths.
- overlay self-evolution skills (`promote-from-project`, `audit-against-kit`,
  `discover-kit-additions`) + `vendor-plugin`/`sync-upstreams` skills depend on
  `kit.config.yml` / `vendored/.upstreams.yml` / sync scripts → cut or rewrite.
- `secrets-hygiene-reviewer` agent ↔ `overlays/rules/secrets.md`.
- `workflow-env-validator.sh` ↔ `overlays/rules/secrets.md` + `.kit/`.
- `ruff-lint.sh` duplicated (overlays + language-packs/python) → dedupe.
