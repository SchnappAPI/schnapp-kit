# Adding a Community Plugin

## One command

```bash
scripts/add-upstream.sh <name> <github-url> <pin>
# Example:
scripts/add-upstream.sh my-plugin https://github.com/user/my-plugin main
```

This:

1. Clones the plugin at the given pin
2. Copies the tree into `vendored/<name>/`
3. Updates `vendored/.upstreams.yml` with the source URL and resolved commit sha
4. Prompts you to update `kit.config.yml` with `enabled_artifacts` / `disabled_artifacts` globs

## Cherry-picking

By default, all artifacts in a vendored plugin are active. To selectively enable or disable:

```yaml
# kit.config.yml
vendored:
  my-plugin:
    source: github:user/my-plugin
    pin: main@<sha>
    enabled_artifacts:
      - skills/foo/**
      - agents/bar.md
    disabled_artifacts:
      - skills/experimental/**
```

After editing `kit.config.yml`, run `scripts/conflict-check.sh` to surface any name collisions.

## Resolving conflicts

If `conflict-check.sh` reports a shadow between your new plugin and an existing layer:

1. **Keep both** if they have different frontmatter `name:` values (they're distinct artifacts).
2. **Disable the lower-priority one** via `disabled_artifacts` in `kit.config.yml`.
3. **Shadow with `overlays/overrides/`** if you want your own version to win — add an entry to `overlays/SHADOWS.md`.

## Re-syncing later

```bash
scripts/sync-upstream.sh <name>
```

Updates the vendored tree to the latest commit on the configured pin branch. Overlays are untouched.

## Committing

```bash
git add vendored/<name>/ vendored/.upstreams.yml kit.config.yml
git commit -m "feat: [vendored] vendor <name> at <short-sha> with <N> cherry-picks"
```
