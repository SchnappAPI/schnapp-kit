# Developing schnapp-kit

## The five evolution mechanisms

### 1. `/discover-kit-additions <repo-url>`

Scan any repo for artifacts the kit doesn't have yet. Returns a ranked candidate list with paste-ready `kit.config.yml` blocks. Compose with `/vendor-plugin` or `/promote-from-project` to act on findings.

### 2. `/audit-against-kit <repo-url-or-path>`

Reverse direction: given a project repo, produce a four-section delta report (uncovered languages, promotion candidates, duplicates, conflicts). Run before adopting the kit in a project.

### 3. `/promote-from-project <source-path> --type <kind> --name <slug>`

Copy a project-local artifact into `overlays/`. Runs validators and conflict-check. The promoted file lands in `overlays/<kind>/<slug>` ready to commit.

### 4. `/vendor-plugin <github-url>`

Wrapper around `scripts/add-upstream.sh`. Lowers the friction of trying a new community plugin to one command.

### 5. `/sync-upstreams`

Bumps pins on `core/` (ECC) and all `vendored/*` entries, runs tests, surfaces breaking changes. Run weekly or on demand.

## Layer discipline

- **Never edit** `core/` or `vendored/<plugin>/` directly. They are synced from upstream.
- To override: put a same-named file in `overlays/overrides/` and add a note to `overlays/SHADOWS.md`.
- `kit.config.yml` is the cherry-pick UI — toggle via `enabled_artifacts` / `disabled_artifacts` globs.

## Running tests

```bash
tests/run-all.sh
```

Individual validators:

```bash
tests/validate-frontmatter.sh  # agent/skill frontmatter fields
tests/validate-hooks.sh        # hooks are executable with shebangs
tests/validate-rules.sh        # rules are well-formed markdown
tests/validate-manifests.sh    # plugin.json + kit.config.yml parse + reference real paths
tests/validate-no-orphans.sh   # every kit.config.yml enabled_artifact glob matches real files
```

## After any change

```bash
scripts/conflict-check.sh
tests/run-all.sh
```

## ADRs

`docs/decisions/ADR-YYYYMMDD-N-slug.md`. Use `/adr` or `/skill adr-writer`. Append-only — shipped ADRs cannot be edited; supersede with a new ADR.

## Commit format

```
<type>: [scope1][scope2] short description — ADR-YYYYMMDD-N
```

Scopes: `[core]`, `[vendored]`, `[overlays]`, `[lang]`, `[scripts]`, `[docs]`, `[tests]`, `[meta]`, `[all]`.

The commit-msg hook (installed via `.githooks/`) enforces this format. Post-commit hook auto-pushes to origin.
