# Proposed cuts — batch 3: held core machinery (16)

These are NOT user-facing artifacts — they're the ECC engine/infrastructure,
deliberately HELD during the artifact passes. Cuts here = deleting whole core/
subtrees (the kit already deletes from core/ via prune-languages.sh, so this is
in-model). Blast-radius checked: **0 import/require coupling** between the cut
candidates and the kept engine. Reply with deltas, "approve all", or
"leave all held" if you'd rather not touch the engine yet.

**Tally:** propose KEEP 10 · propose CUT 6 · ~24 MB reclaimed

## Propose CUT (ECC-product bloat, no coupling to kept engine)
- `core/assets/` — 22 MB of ECC **marketing images** (tweet headers, security diagrams). Biggest single item in the repo.
- `core/ecc2/` — 1.9 MB independent **Rust project** (ECC v2). Self-contained; only reader is `observability-readiness.js` (itself ECC-product tooling).
- `core/src/` — ECC **llm** Python CLI source (`src/llm/`). Not used by kit scripts.
- `core/research/` — ECC research materials.
- `core/integrations/` — `aura` integration (ECC-specific).
- `core/legacy-command-shims/` — legacy command compat shims.

## Propose KEEP (load-bearing engine + config)
- `core/scripts/` — build/CI/codemap/hooks engine the kit runs on. *(Note: a few ECC-product scripts like `observability-readiness.js` go dead once ecc2 is cut — flag for a later finer script-level prune.)*
- `core/hooks/` — core hooks + memory-persistence (referenced by kit layer).
- `core/schemas/` — JSON validation for hooks/plugins.
- `core/manifests/` — install-components/modules/profiles (installer).
- `core/plugins/` — plugin definitions.
- `core/mcp-configs/` — `mcp-servers.json`.
- `core/config/` — `project-stack-mappings.json`.
- `core/.mcp.json` — root MCP server config.
- `core/tests/` — test suite that validates the kit (conflict-check relies on it).
- `core/examples/` — `keep_examples: true` is already set in kit.config.yml.
