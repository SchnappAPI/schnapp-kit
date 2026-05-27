---
name: live-session-cache
description: Capture each session turn to a chat/* branch so context survives compaction or accidental session loss. Default mode is `always` in Claude Code, `trigger` in claude.ai. Projects can override defaults by placing their own SKILL.md in .claude/skills/live-session-cache/.
---

# Live Session Cache

Captures each session turn to a dedicated `chat/` branch so context survives compaction or accidental session loss.

## Modes

- `always` — chat branch is created at session start (recommended for Claude Code).
- `trigger` — activates on first non-chats write (default for claude.ai to avoid overhead on throwaway sessions).
- `manual` — only activates when the user explicitly requests capture.

Projects can override the mode in their local `.claude/skills/live-session-cache/SKILL.md`.

## Branch and file convention

- Branch name: `chat/YYYY-MM-DD-{slug}` off `main`.
- File location while active: `chats/in-progress/{slug}.md`.
- File location after wrap-and-merge: `chats/archive/{YYYY}/{MM}/{slug}.md`.

The chat branch is always separate from the work branch. Repo edits proceed on their normal branch. The chat log is purely context.

## Integration with the session lifecycle

The chat log does NOT replace session-end updates. All required updates still apply:

- Properly formatted commit subjects on the work branch.
- Updating project documentation (README sections, ADRs, MEMORY.md) as warranted.
- `MEMORY.md` / `LEARNED.md` updates per session lifecycle rules.

The chat log supplements these by preserving the discussion that produced the commits.

## What does NOT go in the chat log

- Credentials, API keys, secrets. Redact at write time.
- Long file contents pasted by the user.
- Code that was never accepted by the user.

## Per-turn entry format

```
## Turn N — YYYY-MM-DD HH:MM

### User
{verbatim user message}

### Reasoning
{2 to 5 sentence summary of approach taken}

### Response
{verbatim assistant response}

### Evolution note
{when this turn caused a reframing. Omit when not applicable.}

### State delta
{decisions made, files touched with commit hashes, errors hit, open questions. Write "No state change" rather than omitting.}
```

Commit message format on the chat branch: `chat: turn N — {short description}`.

## PR convention

Wrap-and-merge opens a PR from the chat branch to `main`. PR title: `chat: {slug}`. PR body: the final summary block from the file. Squash-merge recommended.
