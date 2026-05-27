# ADR-20260526-1: Layered distribution — ECC core, vendored community plugins, schnapp-bet overlays

**Status**: Accepted
**Date**: 2026-05-26

## Context

A personal Claude Code distribution needs to absorb three streams of content over time: upstream community projects (ECC, mattpocock/skills, future plugins), schnapp-bet's accumulated conventions, and the user's net-new additions. The naive single-tree approach (just merge everything into one `.claude/`) makes upstream re-syncs painful and conflict resolution invisible.

## Decision

Adopt a four-layer architecture, layered lowest-to-highest priority:

1. **`core/`** — fork of ECC (https://github.com/affaan-m/ECC), pruned only of language packs we don't use (Java, Ruby, etc.). All examples and reference files kept. Re-synced from upstream via `scripts/sync-upstream.sh core`.
2. **`vendored/<name>/`** — third-party plugins, each as a git-subtree at a pinned commit. Re-synced via `scripts/sync-upstream.sh <name>`. Cherry-picking happens at the `kit.config.yml` level via `enabled_artifacts` / `disabled_artifacts` globs — never edit vendored files directly.
3. **`language-packs/<lang>/`** — opt-in, opinionated per-language additions on top of ECC's defaults.
4. **`overlays/`** — schnapp-bet promotions and net-new artifacts. Highest priority; same-named files here shadow lower layers.

The consuming project's `.claude/` directory layers on top of everything.

## Consequences

- Adding a new upstream is one repeatable command.
- Re-syncing an upstream never clobbers user changes (they live in `overlays/`).
- Conflicts are explicit and surfaced by `scripts/conflict-check.sh`.
- The cost is a slightly more complex render step (`scripts/render-merged-tree.sh`) for surfaces that don't natively understand the layer system.

## Alternatives considered

- **Flat tree, merge by hand** — Rejected. Upstream re-syncs become merge conflicts; cherry-picking becomes file deletion that has to be re-done each sync.
- **Submodules instead of subtrees** — Considered for `vendored/`. Rejected for v1: submodule init friction is high, and the upstreams we vendor are small enough that the disk-space cost of subtrees is negligible. Revisit if a vendored upstream grows past ~100 MB.
- **Start from schnapp-bet and import ECC pieces** — Rejected. Throws away ECC's 75 agents / 246 skills / 95 commands of curation.
