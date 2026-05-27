#!/usr/bin/env bash
# SessionStart: prune stale remote refs, delete gone local branches, surface orphaned PRs.
# Runs silently when state is clean — only injects additionalContext when action is needed.

# Prune stale remote-tracking refs
git remote prune origin 2>/dev/null || true

# Delete local branches whose upstream is gone (safely: -d only deletes fully merged branches)
GONE_BRANCHES=$(git branch -vv 2>/dev/null | grep ': gone]' | grep -v '^\*' | awk '{print $1}')
DELETED_MSG=""
if [[ -n "$GONE_BRANCHES" ]]; then
  while IFS= read -r branch; do
    [[ -z "$branch" ]] && continue
    if git branch -d "$branch" 2>/dev/null; then
      DELETED_MSG="${DELETED_MSG}  - deleted '${branch}' (remote gone, was merged)\n"
    fi
  done <<< "$GONE_BRANCHES"
fi

# Surface PRs whose branch no longer exists on remote (orphaned — branch deleted but PR still open)
ORPHANED_MSG=""
PR_JSON=$(gh pr list --json number,headRefName 2>/dev/null || echo "[]")
while IFS= read -r pr_num; do
  [[ -z "$pr_num" ]] && continue
  branch=$(echo "$PR_JSON" | python3 -c "
import sys, json
prs = json.load(sys.stdin)
for pr in prs:
    if str(pr['number']) == sys.argv[1]:
        print(pr['headRefName'])
        break
" "$pr_num" 2>/dev/null)
  [[ -z "$branch" ]] && continue
  if ! git ls-remote --exit-code origin "$branch" > /dev/null 2>&1; then
    ORPHANED_MSG="${ORPHANED_MSG}  - PR #${pr_num} references deleted branch '${branch}' — close it\n"
  fi
done < <(echo "$PR_JSON" | python3 -c "import sys,json; [print(p['number']) for p in json.load(sys.stdin)]" 2>/dev/null)

# Build output — only emit if something to report
MSG=""
[[ -n "$DELETED_MSG" ]] && MSG="${MSG}Cleaned stale branches:\n${DELETED_MSG}"
[[ -n "$ORPHANED_MSG" ]] && MSG="${MSG}Orphaned PRs (close these before new work):\n${ORPHANED_MSG}"
[[ -z "$MSG" ]] && exit 0

python3 -c "
import json, sys
msg = sys.argv[1]
print(json.dumps({
    'hookSpecificOutput': {
        'hookEventName': 'SessionStart',
        'additionalContext': msg.replace('\\\\n', '\n')
    }
}))
" "$MSG"

exit 0
