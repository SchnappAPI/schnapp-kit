---
name: adr
description: Create today's ADR with the next counter. Pairs with skills/adr-writer/. Default path is docs/decisions/ — override by setting adr_path in your project's .claude/skills/adr-writer/SKILL.md.
disable-model-invocation: true
---

Create an ADR in `docs/decisions/` (or the path configured in `.claude/skills/adr-writer/SKILL.md`) using today's date and the next sequential counter.

1. Determine the ADR path: read `adr_path` from `.claude/skills/adr-writer/SKILL.md` if present; default to `docs/decisions/`.
2. Compute today's date: `date +%Y%m%d`.
3. Compute the next counter: `ls <adr_path>/ADR-$(date +%Y%m%d)-*.md 2>/dev/null | wc -l` returns N already used today; next counter is `N + 1`.
4. Ask the user for: a short slug (kebab-case, used in the filename) and a one-line title (used as the file's H1).
5. Ask the user for the body fields: `Context:` (why this came up), `Decision:` (what was decided), `Consequences:` (what this implies for future work), and optional `Supersedes:` (reference to a prior ADR being superseded).
6. Write the file to `<adr_path>/ADR-YYYYMMDD-N-slug.md` using this template:

```markdown
# ADR-YYYYMMDD-N: {title}

Date: YYYY-MM-DD
Status: Accepted

## Context

{context paragraph}

## Decision

{decision paragraph}

## Consequences

{consequences paragraph}

{optional: ## Supersedes
ADR-XXXXXXXX-N (one-line reason).}
```

7. Confirm the file was created. Report the path back to the user.

Do not commit the file as part of this command — leave that to the user's normal session-end flow. The commit subject for the change that motivated this ADR should reference the ADR with the `— ADR-YYYYMMDD-N` suffix.
