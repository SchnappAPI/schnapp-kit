# schnapp-kit cleanup — final keep/cut manifest

**Phase 3 decision pass complete; direction = Flatten & own (PLAN.md).** Every
artifact decided. Source of truth: `docs/cleanup/inventory.tsv`. Rationale:
`proposed-cuts.md` / `-2.md` / `-3.md`.

> Status: decisions DONE. Apply (Phase 4 flatten) + verify (Phase 5) remain.

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
| Core machinery | 0 | 16 | 16 |
| **Total** | **272** | **185** | **457** |

## What gets cut (185 rows)

- **Pruned-language stacks** — Java/Spring/Quarkus, Kotlin/Android, PHP/Laravel, Swift/iOS, C++, .NET, Angular.
- **Niche verticals** — healthcare, trading/web3, marketing/sales/social, supply-chain, networking/homelab, scientific/biomed, media/video.
- **ECC-product internals** — `ecc-guide`, `configure-ecc`, `*-ops` family, GAN harness, `auto-update`, `cost-tracking`.
- **Core machinery (flatten)** — all 16 held trees: `assets`(22MB), `ecc2`, `src`, `tests`, `scripts`, `examples`, `schemas`, `manifests`, `plugins`, `hooks`, `config`, `mcp-configs`, `research`, `integrations`, `legacy-command-shims`, `.mcp.json`. Plus `kit.config.yml` + sync scripts at flatten. Runtime hooks survive in `overlays/hooks/`.
- **Superseded** — `continuous-learning` v1; mattpocock `deprecated/`+`in-progress/`.

## Apply plan (Flatten & own)

1. `git rm` the 185 cut paths still present (skip Phase-1-removed).
2. Flatten keepers to single-layer (`skills/ agents/ commands/ rules/ contexts/`); fold language-packs; relocate `LICENSE`+`ATTRIBUTION.md` to root.
3. Drop fork/sync machinery (`kit.config.yml`, sync `scripts/`, `vendored/.upstreams.yml`); give up upstream re-sync.
4. Rewrite references; dangling-ref grep; hook smoke test.
5. ADR documenting the cull + flatten.
