# schnapp-kit cleanup — STATUS (resume here)

This file + `docs/cleanup/ledger.tsv` are the **entire cross-session memory**.
Full plan: `docs/cleanup/PLAN.md`. Every session: read this → resume at the named
phase → operate on the ledger → update both → commit.

**Goal:** *Flatten & own* — keep only used artifacts in a flat, single-layer
layout; delete the fork/sync machinery. Give up upstream ECC re-sync (intended).

**Decisions locked (do not re-litigate):**
- Flatten & own (not curate-via-config).
- Bulk-first, then file-by-file grilling on survivors.
- Surfaces: **CLI + web/Cowork** → cut other-editor mirrors (.cursor/.kiro/…),
  but **keep a simplified web/Cowork install path** (group D2 — do not delete
  blindly).

**Current phase:** Phase 1 — Bulk cuts, walking 8 sections with per-section
sign-off + commit (delete-per-section cadence).

**Sections done:** 1 (6 adapter guides), 2 (1,165 localized docs), 3 (319
editor mirrors / group A), 4 (79 ECC-internal core/docs cut; 8 guides KEPT),
5 (30 ECC repo internals cut — all core/.github + ECC-specific core/.claude;
4 HELD for Phase 3: core/.claude/commands/{add-language-rules,database-migration,
feature-development}.md + rules/node.md — review vs core/commands & core/rules).
**Next action:** Section 6 — pruned-language artifacts (group C, ~68 across
core/skills, core/agents, core/rules). Then Section 7 (group F disabled vendored
plugins, 8) and Section 8 (ECC root scaffolding). Big buckets (core/skills 401,
agents 61, commands 76, ecc2/src/tests/scripts/examples/assets) → Phase 2/3.
Tracked: 1,380.

**PR:** #4 (cleanup, open, merge at the very end). ecc-tools[bot] auto-opens a
bundle PR on every push — AUTO-CLOSE silently without merging (per user; #5–#8
closed); bot stays installed.

## Phase checklist
- [x] Phase 0 — Setup (branch `claude/dreamy-ptolemy-vITDt`, ledger, STATUS, PLAN copy)
- [ ] Phase 1 — Bulk cuts (groups A–F, ~2,061 files)
- [ ] Phase 2 — Inventory survivors (scripted frontmatter sweep → ledger rows)
- [ ] Phase 3 — File-by-file grilling (survivors only)
- [ ] Phase 4 — Flatten & reorganize (move keepers, fold lang-packs, rewrite refs)
- [ ] Phase 5 — Verify (trim tests, dangling-ref grep, hook smoke test, PR)

## Bulk-cut groups (Phase 1)
- **A** editor mirrors + ECC meta dot-dirs (`core/.agents .kiro .opencode .cursor
  .codebuddy .codex .codex-plugin .trae .zed .gemini .qwen .github .claude`) ≈ 353
- **B** localized docs (ja/zh/tr/ko/pt/etc.) + ECC english project docs ≈ 1,258
- **C** pruned-language artifacts (rules/skills/agents) ≈ 68
- **D** fork/sync/build machinery (scripts + kit.config.yml + .upstreams.yml)
- **D2** web/Cowork install path — *keep, simplified* (user uses web)
- **E** ECC project scaffolding (ecc2, src, tests, scripts, examples, assets,
  legacy shims, schemas, root build/meta files) ≈ 500
- **F** already-disabled vendored output-style plugins ≈ 8

## Notes / known issues to fix during flatten
- Docs reference nonexistent `overlays/overrides/` and `overlays/SHADOWS.md`.
- `overlays/skills/{vendor-plugin?,sync-upstreams?,promote-from-project}` and
  `audit-against-kit`/`discover-kit-additions` depend on the layered-fork model →
  cut or rewrite after flatten. (Only adr-writer, workflow, live-session-cache,
  audit-against-kit, discover-kit-additions actually exist as overlay skills.)
- `ruff-lint.sh` exists twice (overlays/hooks + language-packs/python/hooks) —
  dedupe at flatten.
- `stop-reminder.sh` is wired in hooks.json (Stop) — keep with its hook group.
