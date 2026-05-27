# Adding a Language Pack

Language packs live in `language-packs/<lang>/` and follow the same subdirectory structure as `core/` and `overlays/`:

```
language-packs/<lang>/
  agents/
  skills/
  commands/
  hooks/
  rules/
  examples/
```

## Steps

### 1. Create the directory

```bash
mkdir -p language-packs/<lang>/{agents,skills,commands,hooks,rules,examples}
```

### 2. Add content

Start with whatever you have — even a single rules file is a valid v1 pack. Common starting points:

- `rules/<lang>.md` — project conventions for this language (linting, formatting, testing patterns).
- `hooks/<linter>.sh` — PostToolUse hook to auto-lint on file save.
- `agents/<reviewer>.md` — language-specific code reviewer agent.

### 3. Enable the pack

Add the language name to `kit.config.yml`:

```yaml
language_packs_enabled: [python, typescript, sql, infra, <lang>]
```

### 4. Verify

```bash
scripts/detect-languages.sh <some-repo-that-uses-this-lang>
# Should now list <lang> as covered rather than as an unrecognized language.

tests/run-all.sh
```

### 5. Commit

```bash
git add language-packs/<lang>/
git commit -m "feat: [lang][<lang>] add <lang> language pack"
```

## Tips

- **Don't duplicate ECC content.** `core/` already has solid coverage for most languages. Language packs are for _your opinionated additions_ on top of ECC defaults — project-specific tooling preferences, custom linters, conventions ECC doesn't cover.
- **Start thin.** One rule file is better than an empty pack. Add more as you discover gaps via `/audit-against-kit`.
- **Detection.** Add file extensions and manifest names to `scripts/detect-languages.sh` so the script recommends the new pack when it scans repos using that language.
