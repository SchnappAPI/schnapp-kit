# Phase 2 Inventory Digest — orientation for Phase 3 grilling

Full data: `docs/cleanup/inventory.tsv` (457 rows; columns
`path｜type｜group｜purpose｜deps｜size｜decision｜target_path｜notes`).
Decisions so far: **10 cut** (disabled vendored), **16 held-phase3** (machinery
trees), **431 undecided** (the real grilling queue).

## Grilling queue (431 undecided), by bucket
- **core/skills — 225** (the main event). Suggested batch order by domain cluster
  (name prefix): agent*(6), then framework/lang skills, infra/devops, security,
  content/marketing, science/health/finance, misc.
- **core/commands — 64**
- **core/agents — 46**
- **core/rules — 39** (common, python, typescript, web, cpp, angular subdirs)
- **vendored — 35 active** (45 listed − 10 disabled): agent-sdk-dev, plugin-dev,
  ralph-wiggum, security-guidance, mattpocock active skills
- **overlays — 11** (mostly keepers; 2 fork-coupled need cut/rewrite)
- **core/contexts — 3**, **language-packs — 4**, **core/.claude held — 4**

## Flags raised by the dependency sweep (act on in Phase 3)
1. **Framework skills for PRUNED languages** (missed by Section 6 name-match):
   `springboot`(4 files-ish), `quarkus`(4), `laravel`(5) → Java/PHP frameworks.
   Strong cut candidates — confirm during the skills grill.
2. **Disabled vendored (already cut):** 8 mattpocock skills under
   deprecated/in-progress/migrate-to-shoehorn/obsidian-vault — excluded by
   kit.config `disabled_artifacts`; marked `cut` in inventory, will not flatten.
3. **Fork-coupled overlay skills:** `audit-against-kit`, `discover-kit-additions`
   reference deleted sync machinery (kit.config, .upstreams, sync/promote
   scripts). Decide **cut or rewrite** — they lose meaning once flattened.
4. **Travel-together bundles (18 skills):** keep = bring the whole dir. Biggest:
   `angular-developer`(36), `remotion-video-creation`(29), `skill-comply`(14),
   `videodb`(12), `continuous-learning-v2`(7), `openclaw-persona-forge`(7),
   `tinystruct-patterns`(7), `frontend-slides`(6), `lead-intelligence`(5).
5. **Linked pairs (keep/cut together):** secrets-hygiene-reviewer ↔
   rules/secrets.md; adr command ↔ adr-writer skill; status command →
   scripts/status.sh (missing — degrades gracefully).
6. **continuous-learning-v2 skill** ↔ kept doc `continuous-learning-v2-spec.md`
   (sec4). If the skill is cut, revisit that doc.

## Phase 3 mechanics
Walk `decision=undecided` rows in inventory.tsv by bucket/batch. Present
name + purpose + deps; user says keep/cut (drill for full content on request).
Write decision back to inventory.tsv (and mirror final keeps into ledger.tsv at
flatten). A keep on a bundle/linked row pulls its whole dir / partner along.
