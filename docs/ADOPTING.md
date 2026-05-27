# Adopting schnapp-kit

## Claude Code (plugin install)

```bash
# Install from GitHub:
claude plugin install github:schnappapi/schnapp-kit

# Install from local path (for testing pre-publish):
claude plugin install /path/to/schnapp-kit
# or: scripts/install-as-plugin.sh
```

All artifacts in `core/`, `vendored/*/`, `language-packs/<enabled>/`, and `overlays/` are auto-discovered in that order.

## Claude.ai web / Cowork

These surfaces don't support plugin discovery roots. Use the merged-tree symlink approach:

```bash
scripts/install-user-global.sh
```

This runs `render-merged-tree.sh` to materialize the post-merge view, then symlinks it into `~/.claude/`. Re-run after any kit update.

**Note:** hooks are not active on Claude.ai web or Cowork. Only agents, skills, commands, and rules are effective on those surfaces.

## Per-project configuration

After installing the kit, create `.claude/kit.local.yml` in the consuming project to opt in/out of specific artifacts:

```yaml
# .claude/kit.local.yml — project-level kit overrides
language_packs_enabled: [python, typescript] # subset of kit defaults
disabled_artifacts:
  - overlays/skills/live-session-cache/** # not needed for this project
```

Projects can also place their own files in `.claude/` to shadow kit artifacts — the project's `.claude/` is always highest priority.

## Adopting in schnapp-bet (when ready)

1. `/plugin install github:schnappapi/schnapp-kit`
2. `scripts/detect-languages.sh ~/code/schnapp-bet` — confirms `[python, typescript, sql, infra]`
3. Create `schnapp-bet/.claude/kit.local.yml` with enabled packs + any per-project disables
4. Reconcile duplicates: delete schnapp-bet's local copies of artifacts the kit now serves (universal hooks, universal skills, secrets-hygiene-reviewer). Keep domain-specific things (etl-integrity-reviewer, `/grade`, `/etl`, `/deploy`, the eight rules files)
5. Create `ln -s decisions docs/adr` for mattpocock-skills ADR path compatibility
6. Smoke test + write adoption ADR in schnapp-bet

## Detecting which language packs to enable

```bash
scripts/detect-languages.sh <repo-path>
```

Outputs recommended `language_packs_enabled` list and flags languages the repo uses that have no kit pack yet.
