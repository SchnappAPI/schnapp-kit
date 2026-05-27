# schnapp-kit

A personal, layered Claude Code distribution. Fork of [affaan-m/ECC](https://github.com/affaan-m/ECC), with community plugins vendored on top and schnapp-bet's universal artifacts overlaid.

**Install**: `/plugin install github:schnappapi/schnapp-kit`

**Layers** (low → high priority):

1. `core/` — ECC fork, pruned to enabled languages, examples kept.
2. `vendored/` — third-party plugins, version-pinned (currently: mattpocock/skills).
3. `language-packs/` — opt-in per-language additions (python, typescript, sql, infra).
4. `overlays/` — schnapp-bet promotions and kit-native skills.

**Status**: v1 is a starting point. Use `/discover-kit-additions` and `/audit-against-kit` to grow it.

See `docs/ARCHITECTURE.md` for the layer model and `docs/ADOPTING.md` for install instructions per surface (Claude Code plugin, Claude.ai user-global, Cowork).
