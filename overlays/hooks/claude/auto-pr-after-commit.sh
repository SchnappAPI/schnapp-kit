#!/usr/bin/env bash
# PostToolUse(Bash): auto-create PR after committing on a feature branch.
# Async — non-blocking. Fires after git commit (post-commit hook auto-pushes).

INPUT=$(cat)
CMD=$(echo "$INPUT" | python3 -c "
import sys, json
try:
    d = json.load(sys.stdin)
    print(d.get('tool_input', {}).get('command', ''))
except Exception:
    pass
" 2>/dev/null || echo "")

[[ -z "$CMD" ]] && exit 0

echo "$CMD" | grep -qE 'git[[:space:]]+commit' || exit 0

BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "")
[[ -z "$BRANCH" || "$BRANCH" == "main" || "$BRANCH" == "master" || "$BRANCH" == "HEAD" ]] && exit 0

# Push branch to remote if not already there
git ls-remote --exit-code origin "$BRANCH" > /dev/null 2>&1 || {
  git push -u origin "$BRANCH" 2>/dev/null || exit 0
}

# Skip if PR already exists for this branch
EXISTING=$(gh pr list --head "$BRANCH" --json number --jq '.[0].number' 2>/dev/null || echo "")
[[ -n "$EXISTING" ]] && exit 0

gh pr create --fill --base main --head "$BRANCH" 2>/dev/null || true
exit 0
