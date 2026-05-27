#!/bin/bash
# Stop hook — fires at end of every Claude turn.
# Safety net: if HEAD is ahead of its upstream, push it.
# Covers post-commit failures (network blip) and fresh clones
# where core.hooksPath was not yet set when the commit landed.

INPUT=$(cat)
if [ "$(echo "$INPUT" | jq -r '.stop_hook_active')" = "true" ]; then
  exit 0
fi

LOCAL=$(git -C "${CLAUDE_PROJECT_DIR}" rev-parse HEAD 2>/dev/null)
UPSTREAM=$(git -C "${CLAUDE_PROJECT_DIR}" rev-parse '@{u}' 2>/dev/null)
if [[ -n "$LOCAL" && -n "$UPSTREAM" && "$LOCAL" != "$UPSTREAM" ]]; then
  AHEAD=$(git -C "${CLAUDE_PROJECT_DIR}" rev-list --count "${UPSTREAM}..HEAD" 2>/dev/null)
  if [[ "$AHEAD" -gt 0 ]]; then
    echo "[stop-reminder] HEAD is $AHEAD commit(s) ahead of origin — pushing." >&2
    git -C "${CLAUDE_PROJECT_DIR}" push --quiet 2>&1 | sed 's/^/[stop-reminder] /' >&2 || true
  fi
fi

exit 0
