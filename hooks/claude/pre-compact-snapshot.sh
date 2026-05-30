#!/usr/bin/env bash
# PreCompact: snapshot git/task state + back up the transcript before compaction.
# PreCompact is side-effect only (it cannot inject context), so the snapshot is
# surfaced later by session-resume-breadcrumb.sh on the next SessionStart.
# Never block compaction — always exit 0.
set -uo pipefail

INPUT=$(cat)
PROJ="${CLAUDE_PROJECT_DIR:-$PWD}"
STATE_DIR="${HOME}/.claude/schnapp-kit"
mkdir -p "${STATE_DIR}/transcripts" 2>/dev/null || true

# Stable per-repo key so PreCompact and the SessionStart reader agree on the file.
KEY=$(python3 -c "import hashlib,sys;print(hashlib.sha1(sys.argv[1].encode()).hexdigest()[:12])" "$PROJ" 2>/dev/null || echo default)

TRIGGER=$(printf '%s' "$INPUT" | python3 -c "import sys,json;print(json.load(sys.stdin).get('trigger',''))" 2>/dev/null || echo "")
TRANSCRIPT=$(printf '%s' "$INPUT" | python3 -c "import sys,json;print(json.load(sys.stdin).get('transcript_path',''))" 2>/dev/null || echo "")

cd "$PROJ" 2>/dev/null || true
BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "")
HEAD=$(git rev-parse --short HEAD 2>/dev/null || echo "")
AHEAD=$(git rev-list --count origin/main..HEAD 2>/dev/null || echo "0")
CHANGED=$(git status --porcelain 2>/dev/null | wc -l | tr -d ' ')
COMMITS=$(git log --oneline -3 2>/dev/null || echo "")

python3 - "${STATE_DIR}/compaction-${KEY}.json" "$TRIGGER" "$BRANCH" "$HEAD" "$AHEAD" "$CHANGED" "$COMMITS" "$PROJ" <<'PY' 2>/dev/null || true
import json, sys, datetime
path, trigger, branch, head, ahead, changed, commits, proj = sys.argv[1:9]
json.dump({
    "ts": datetime.datetime.now().isoformat(timespec="seconds"),
    "trigger": trigger, "project": proj, "branch": branch, "head": head,
    "ahead_of_main": ahead, "changed_files": changed,
    "recent_commits": [l for l in commits.splitlines() if l.strip()],
}, open(path, "w"))
PY

# Best-effort transcript backup; keep the dir bounded (GC > 7 days).
if [[ -n "$TRANSCRIPT" && -f "$TRANSCRIPT" ]]; then
  cp -f "$TRANSCRIPT" "${STATE_DIR}/transcripts/${KEY}-$(date +%Y%m%d-%H%M%S).jsonl" 2>/dev/null || true
fi
find "${STATE_DIR}/transcripts" -type f -name '*.jsonl' -mtime +7 -delete 2>/dev/null || true

exit 0
