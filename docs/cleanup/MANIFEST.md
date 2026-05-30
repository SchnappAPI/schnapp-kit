# schnapp-kit cleanup — final keep/cut manifest

**COMPLETE.** Curated + flattened into a single flat plugin (ADR-20260530-1).
Repo: ~2,977 → 465 tracked files. Source of truth: `inventory.tsv`.

| Bucket | Keep | Cut | Total |
|---|---:|---:|---:|
| Skills | 109 | 116 | 225 |
| Agents | 33 | 13 | 46 |
| Commands | 52 | 12 | 64 |
| Rules | 29 | 10 | 39 |
| Contexts | 3 | 0 | 3 |
| Vendored | 33 | 12 | 45 |
| Overlays | 7 | 4 | 11 |
| Language packs | 4 | 0 | 4 |
| core/.claude (held) | 0 | 4 | 4 |
| Core machinery | 0 | 16 | 16 |
| **Total** | **270** | **187** | **457** |

## Outcome

Flat plugin: `skills/ agents/ commands/ rules/ contexts/ hooks/ docs/ tests/`.
Removed: all pruned-language stacks, niche verticals, ECC-product internals,
core machinery (22 MB assets, ecc2, src, installer), and the fork/sync layer
(`kit.config.yml`, sync `scripts/`, `vendored/.upstreams.yml`). All validators pass.
