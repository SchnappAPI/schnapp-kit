#!/usr/bin/env bash
# PreToolUse(Bash): block git commit when on main/master.
# Forces feature-branch workflow — exits 2 (blocking).

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

echo "$CMD" | grep -qE 'git[[:space:]]+(commit|merge)' || exit 0

BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "")

if [[ "$BRANCH" == "main" || "$BRANCH" == "master" ]]; then
  cat >&2 <<EOF
no-commit-to-main: direct commits to '$BRANCH' are blocked.
Create a feature branch first:
  git checkout -b feat/<short-description>
Then re-run the commit.
EOF
  exit 2
fi

exit 0
