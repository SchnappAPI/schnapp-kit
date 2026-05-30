# schnapp-kit cleanup — final keep/cut manifest

**Phase 3 decision pass complete.** Every artifact in the kit now has a recorded
keep/cut decision. Source of truth: `docs/cleanup/inventory.tsv`. Rationale per
batch: `proposed-cuts.md` (skills), `-2.md` (agents/commands/rules/vendored),
`-3.md` (core machinery).

> Status: decisions DONE. Applying the cuts is the next step (not yet started).

| Bucket | Keep | Cut | Total |
|---|---:|---:|---:|
| Skills | 109 | 116 | 225 |
| Agents | 33 | 13 | 46 |
| Commands | 52 | 12 | 64 |
| Rules | 29 | 10 | 39 |
| Contexts | 3 | 0 | 3 |
| Vendored | 33 | 12 | 45 |
| Overlays | 9 | 2 | 11 |
| Language packs | 4 | 0 | 4 |
| core/.claude (held) | 0 | 4 | 4 |
| Core machinery | 10 | 6 | 16 |
| **Total** | **282** | **175** | **457** |

## What gets cut (171 rows)

- **Pruned-language stacks** — Java/Spring/Quarkus, Kotlin/Android, PHP/Laravel, Swift/iOS, C++, .NET, Angular (skills + reviewers + build cmds + rule dirs).
- **Niche verticals** — healthcare, trading/web3, marketing/sales/social, supply-chain, networking/homelab, scientific/biomed, media/video.
- **ECC-product internals** — `ecc-guide`, `configure-ecc`, `*-ops` family, GAN harness, `auto-update`, `cost-tracking`, plus core subtrees (`assets` 22MB, `ecc2`, `src`, `research`, `integrations`, `legacy-command-shims`).
- **Superseded / deprecated** — `continuous-learning` v1, mattpocock `deprecated/` + `in-progress/`.

## Coupled decisions on record

- Instinct-learning **kept** (`continuous-learning-v2` + 9 `learn/evolve/instinct-*` commands).
- GAN harness **cut** as a unit (skill + 3 agents + 2 commands).
- `opensource-pipeline` **kept** as a unit (skill + 3 agents).

## Next: applying (separate pass)

1. Fresh branch off this one.
2. Realize cuts via `kit.config.yml` toggles + `prune-languages.sh`; delete cut `core/` subtrees.
3. Gate every step with `scripts/conflict-check.sh`.
4. Prune now-orphaned tests/scripts (e.g. `observability-readiness.js` after `ecc2`).
5. ADR documenting the cull.
