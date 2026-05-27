#!/usr/bin/env bash
# PostToolUse(Bash): auto-create PR after committing on a feature branch.
# Async — non-blocking. Fires after git commit (post-commit hook auto-pushes).

LOG="${HOME}/.claude/hook-errors.log"
echo "[$(date -u +%H:%M:%S)] auto-pr-after-commit fired" >>"$LOG"

# Async hooks may not receive stdin — use timeout to avoid blocking
INPUT=$(timeout 5 cat 2>/dev/null || echo "")
echo "[$(date -u +%H:%M:%S)] stdin read done (${#INPUT} bytes)" >>"$LOG"

CMD=$(echo "$INPUT" | python3 -c "
import sys, json
try:
    d = json.load(sys.stdin)
    print(d.get('tool_input', {}).get('command', ''))
except Exception:
    pass
" 2>/dev/null || echo "")

echo "[$(date -u +%H:%M:%S)] cmd='${CMD}'" >>"$LOG"

[[ -z "$CMD" ]] && exit 0

echo "$CMD" | grep -qE 'git[[:space:]]+commit' || exit 0

BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "")
[[ -z "$BRANCH" || "$BRANCH" == "main" || "$BRANCH" == "master" || "$BRANCH" == "HEAD" ]] && exit 0

echo "[$(date -u +%H:%M:%S)] creating PR for branch=${BRANCH}" >>"$LOG"

# Push branch to remote if not already there
git ls-remote --exit-code origin "$BRANCH" > /dev/null 2>&1 || {
  git push -u origin "$BRANCH" 2>>"$LOG" || exit 0
}

# Skip if PR already exists for this branch
EXISTING=$(gh pr list --head "$BRANCH" --json number --jq '.[0].number' 2>/dev/null || echo "")
[[ -n "$EXISTING" ]] && exit 0

gh pr create --fill --base main --head "$BRANCH" 2>>"$LOG" || \
  echo "[$(date -u +%H:%M:%S)] gh pr create failed for ${BRANCH}" >>"$LOG"
exit 0
