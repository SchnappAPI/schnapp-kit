#!/usr/bin/env bash
# SessionStart: inject current git state so Claude knows about stale branches / open PRs.
# Outputs hookSpecificOutput JSON only when there's something to flag.

BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "")
[[ -z "$BRANCH" ]] && exit 0

# Pull latest main quietly to stay current
git fetch origin main --quiet 2>/dev/null || true

# If on main and no open PRs, state is clean — skip injection
if [[ "$BRANCH" == "main" || "$BRANCH" == "master" ]]; then
  OPEN_PRS=$(gh pr list --json number --jq 'length' 2>/dev/null || echo "0")
  [[ "$OPEN_PRS" == "0" || -z "$OPEN_PRS" ]] && exit 0
fi

AHEAD=$(git rev-list --count "origin/main..HEAD" 2>/dev/null || echo "0")
PR_LIST=$(gh pr list --json number,title,headRefName \
  --jq '.[] | "  PR #\(.number): \(.title) [\(.headRefName)]"' 2>/dev/null || echo "")

MSG=""
if [[ "$BRANCH" != "main" && "$BRANCH" != "master" ]]; then
  MSG="WARNING: Session starting on branch '${BRANCH}' (${AHEAD} commits ahead of main)."
  if [[ -n "$PR_LIST" ]]; then
    MSG="${MSG}
Open PRs:
${PR_LIST}
Merge open PRs before starting unrelated work, or continue on the current branch."
  else
    MSG="${MSG}
No open PR found for this branch — consider creating one with: gh pr create --fill"
  fi
else
  MSG="Open PRs need attention before starting new work:
${PR_LIST}"
fi

python3 -c "
import json, sys
msg = sys.argv[1]
print(json.dumps({
    'hookSpecificOutput': {
        'hookEventName': 'SessionStart',
        'additionalContext': msg
    }
}))
" "$MSG"

exit 0
