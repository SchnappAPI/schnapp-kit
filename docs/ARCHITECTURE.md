# Architecture — schnapp-kit

## Layer model

Four layers, merged lowest-to-highest priority:

```
core/           ← ECC fork, pruned of unused languages, examples kept
vendored/*/     ← third-party plugins, version-pinned
language-packs/ ← opt-in per-language additions
overlays/       ← schnapp-bet promotions + kit-native artifacts
                   (highest priority — shadows all lower layers)
  └ consuming project's .claude/  ← ultimate override, not in this repo
```

Higher-priority layers shadow lower layers by **filename** (basename match). A file in `overlays/rules/docs.md` takes precedence over `core/rules/docs.md` when the merged tree is rendered.

## Merge order in practice

When Claude Code loads the kit as a plugin, it discovers artifacts from `discoveryRoots` in `plugin.json`:

```json
"discoveryRoots": ["core", "vendored", "language-packs", "overlays"]
```

For surfaces that don't natively support discovery roots (Claude.ai web, Cowork), `scripts/render-merged-tree.sh` materializes the post-merge view into `.merged-tree/`, and `scripts/install-user-global.sh` symlinks it into `~/.claude/`.

## Conflict resolution

`scripts/conflict-check.sh` walks all layers and reports every artifact name that appears in more than one layer. The output is informational — shadows are expected and intentional. Each intentional shadow in `overlays/` has a note in `overlays/SHADOWS.md` explaining why.

To resolve a conflict:

1. **Keep both** — if they serve different purposes (different frontmatter `name:` values).
2. **Shadow** — put the preferred version in `overlays/overrides/` under the same filename. `conflict-check.sh` will list it; add an entry to `overlays/SHADOWS.md`.
3. **Disable upstream** — add the artifact to `kit.config.yml.vendored.<name>.disabled_artifacts` (never delete from `vendored/`).

## `kit.config.yml` — the steering wheel

`kit.config.yml` controls:

- `core.pinned_commit` — ECC commit to sync from.
- `core.enabled_languages` / `core.pruned_languages` — which language subtrees survive `prune-languages.sh`.
- `vendored.<name>.enabled_artifacts` / `.disabled_artifacts` — per-upstream cherry-pick list (glob patterns).
- `language_packs_enabled` — which packs are active.
- `overlays_priority` — always `highest`.

After any edit to `kit.config.yml`, run `scripts/conflict-check.sh`.

## Upstream re-sync

```bash
# Sync one:
scripts/sync-upstream.sh core               # re-fork ECC
scripts/sync-upstream.sh mattpocock-skills  # bump vendored pin

# Sync all:
scripts/sync-upstream.sh --all
```

Re-sync never touches `overlays/` or `language-packs/`. Conflicts surface as test failures.

## Adding a new upstream

```bash
scripts/add-upstream.sh <name> <github-url> <pin>
```

See `docs/ADDING-A-PLUGIN.md` for the full flow.

## Adding a new language pack

See `docs/ADDING-A-LANGUAGE.md`.

## ADR history

`docs/decisions/` — date-counter format `ADR-YYYYMMDD-N-slug.md`. Same convention as schnapp-bet.
