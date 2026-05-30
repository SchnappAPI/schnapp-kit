#!/usr/bin/env bash
# Stop(asyncRewake): auto-merge feature branch PR when working tree is clean.
# Outputs a line on stdout only when a merge happened — rewakes Claude to report it.

LOG="${HOME}/.claude/hook-errors.log"

BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "")
[[ -z "$BRANCH" || "$BRANCH" == "main" || "$BRANCH" == "master" || "$BRANCH" == "HEAD" ]] && exit 0

# Only merge if nothing staged or modified (untracked files are OK)
DIRTY=$(git status --porcelain 2>/dev/null | grep -v '^??' | head -1)
[[ -n "$DIRTY" ]] && exit 0

# Find an open PR for this branch
PR_NUM=$(gh pr list --head "$BRANCH" --json number --jq '.[0].number' 2>/dev/null || echo "")
[[ -z "$PR_NUM" ]] && exit 0

if gh pr merge "$PR_NUM" --squash --delete-branch 2>>"$LOG"; then
  git checkout main 2>>"$LOG" || true
  git pull origin main --ff-only 2>>"$LOG" || true
  echo "Auto-merged PR #${PR_NUM} (branch: ${BRANCH}) to main. Branch deleted. Now on main."
else
  echo "Auto-merge FAILED for PR #${PR_NUM} (branch: ${BRANCH}). See ~/.claude/hook-errors.log."
fi

exit 0
