# ADR-20260530-1 — Flatten & own the kit

- **Date**: 2026-05-30
- **Status**: Accepted
- **Supersedes**: ADR-20260526-1 (fork ECC and layer), ADR-20260526-2 (subdir vendoring)

## Context

schnapp-kit began as a layered distribution: a synced fork of `affaan-m/ECC`
(`core/`), community plugins vendored beneath `vendored/*/`, opt-in
`language-packs/*/`, and `overlays/` on top — assembled at install time via
`kit.config.yml` + render/sync scripts. That bought re-syncability at the cost
of ~3,000 files, four discovery roots, and machinery (installer, schemas,
manifests, sync scripts) that dwarfed the artifacts actually used.

## Decision

Curate, then **flatten and own**:

1. **Curate** — decide keep/cut on every artifact (recorded in
   `docs/cleanup/inventory.tsv`; rationale in `docs/cleanup/proposed-cuts*.md`;
   summary in `docs/cleanup/MANIFEST.md`). Scoped to a Python + TypeScript + SQL +
   infra stack. Cut pruned-language stacks, niche verticals, ECC-product
   internals, and superseded artifacts.
2. **Flatten** — collapse the four discovery roots into one flat plugin:
   top-level `skills/ agents/ commands/ rules/ contexts/ hooks/`. Merge the three
   `hooks.json` files into one. Fold `language-packs/` into `rules/` + `hooks/`.
   Rewrite `plugin.json` to standard flat discovery (drop `discoveryRoots` +
   `configFile`).
3. **Own** — delete the fork/sync/build machinery (`kit.config.yml`, sync
   `scripts/`, `vendored/.upstreams.yml`, ECC `core/` scaffolding: `ecc2`, `src`,
   `tests`, installer manifests/schemas, 22 MB of marketing `assets`). Give up
   upstream ECC re-sync — intentionally.

## Consequences

- Repo dropped from ~2,977 → ~464 tracked files; one flat plugin, no config.
- No more upstream re-sync; future updates are hand-edited in place. Acceptable:
  the kit is personal and the sync machinery cost more than it returned.
- Attribution preserved in `ATTRIBUTION.md` (ECC + mattpocock + Anthropic plugins).
- Open follow-up: `skills/audit-against-kit` and `skills/discover-kit-additions`
  assume the layered/vendor/sync model and are now semantically stale — to be
  rewritten for the flat model or cut.
