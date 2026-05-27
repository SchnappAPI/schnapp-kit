---
name: adr-writer
description: Author an Architecture Decision Record. Use when the current change is "milestone" tier (non-obvious decision, new convention, architectural shift) or when the user references an ADR by number that does not yet exist. Default ADR path is `docs/decisions/` — configurable via frontmatter `adr_path` if the project uses a different directory (e.g. `docs/adr/`). Companion to the `/adr` slash command — both produce the same on-disk format, but this skill is Claude-invocable for session-end ceremony.
adr_path: docs/decisions
---

# adr-writer

Single source for ADR authoring. Mirrors `/adr` but is Claude-invocable so session-end ceremony can be honored without user prompting.

## Configuration

The `adr_path` frontmatter key controls where ADRs are written. Default: `docs/decisions/`. Projects that adopted mattpocock's convention use `docs/adr/`. Set in the consuming project's `.claude/skills/adr-writer/SKILL.md` overlay:

```yaml
adr_path: docs/adr
```

## When this fires

Scale ceremony by task size. Trigger this skill at session end whenever any of these are true:

- The change introduces a **new convention** (commit format, file layout, naming policy, tag taxonomy).
- The change makes a **non-obvious tradeoff** that a future reader would otherwise re-litigate.
- The change is an **architectural shift** (new layer, removed layer, swapped dependency, security boundary).
- The user said "let's decide X" or "going forward we will Y".
- The user references an ADR number (`ADR-YYYYMMDD-N`) that does not exist on disk.

Do **not** fire for: routine ports, single-file fixes, doc cleanups, mechanical renames.

## Procedure

### 1. Compute the filename

```bash
ADR_PATH=<adr_path from frontmatter, default: docs/decisions>
DATE=$(date +%Y%m%d)
N=$(( $(ls ${ADR_PATH}/ADR-${DATE}-*.md 2>/dev/null | wc -l) + 1 ))
SLUG=<kebab-case-from-decision-topic>
FILE="${ADR_PATH}/ADR-${DATE}-${N}-${SLUG}.md"
```

The slug is short (2–5 words), describes the decision not the context.

### 2. Write the file

ADRs are append-only — never edit a shipped one. To revise a prior decision, write a new ADR with `Supersedes:` pointing back.

```markdown
# ADR-YYYYMMDD-N — <one-line decision title in sentence case>

Date: YYYY-MM-DD
Status: Accepted
Supersedes: ADR-XXXXXXXX-N — <one-line reason> (optional, omit if none)

## Context

<Why this came up. Two to five short paragraphs.>

## Decision

<What was decided, numbered when multiple sub-decisions hang together. Imperative voice.>

## Consequences

<Costs and benefits. Required follow-up. Rules that move into CLAUDE.md.>

## Out of scope

<Optional. What this ADR explicitly does NOT decide.>
```

### 3. Wire into the commit subject

The commit that motivated the ADR references it: `<type>: [scope] short description — ADR-YYYYMMDD-N`. This is the only mechanical link between the change and the decision.

### 4. Verify and report

- File written at computed path.
- Filename matches `ADR-\d{8}-\d+-[a-z0-9-]+\.md`.
- All required sections present.
- Date in `Date:` line matches the filename date.

Report the path back. Do **not** commit — leave that to the session-end commit step.

## Anti-patterns

- Writing an ADR for a routine change.
- Editing a shipped ADR.
- Bundling multiple unrelated decisions in one ADR.
- Omitting `Supersedes:` when replacing a decision.
