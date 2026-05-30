# Attribution — core/ layer

The `core/` directory is a fork of [affaan-m/ECC](https://github.com/affaan-m/ECC).

- **Source**: https://github.com/affaan-m/ECC
- **Pinned commit**: 928076cc08cbb31e8549cea2883b4f51811de1c8
- **Forked**: 2026-05-27T02:35:47Z
- **License**: see upstream LICENSE file

## What changed after forking

Language packs for unused languages were pruned (see `scripts/prune-languages.sh` and `kit.config.yml.core.pruned_languages`). No other modifications to the upstream tree — all examples, output styles, statuslines, workflow templates, MCP server templates, and cross-cutting agents/skills/commands are kept intact.

To re-sync: `scripts/sync-upstream.sh core`
