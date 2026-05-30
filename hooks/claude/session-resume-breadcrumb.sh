#!/usr/bin/env bash
# SessionStart: if a pre-compaction breadcrumb exists for this repo, surface it
# as additionalContext (one-shot), so task state survives compaction/resume.
# Silent when there is no recent breadcrumb.
set -uo pipefail

cat >/dev/null 2>&1 || true  # drain stdin (SessionStart payload, unused here)

PROJ="${CLAUDE_PROJECT_DIR:-$PWD}"
STATE_DIR="${HOME}/.claude/schnapp-kit"
KEY=$(python3 -c "import hashlib,sys;print(hashlib.sha1(sys.argv[1].encode()).hexdigest()[:12])" "$PROJ" 2>/dev/null || echo default)
CRUMB="${STATE_DIR}/compaction-${KEY}.json"

[[ -f "$CRUMB" ]] || exit 0

python3 - "$CRUMB" <<'PY' 2>/dev/null || exit 0
import json, sys, os, datetime
p = sys.argv[1]
try:
    d = json.load(open(p))
except Exception:
    sys.exit(0)
# Only surface recent breadcrumbs (< 24h); otherwise drop it.
try:
    if (datetime.datetime.now() - datetime.datetime.fromisoformat(d.get("ts", ""))).total_seconds() > 86400:
        os.remove(p); sys.exit(0)
except Exception:
    pass
lines = [
    f"Resuming after compaction ({d.get('trigger', '?')}) — snapshot from {d.get('ts', '?')}:",
    f"  branch {d.get('branch', '?')} @ {d.get('head', '?')} "
    f"({d.get('ahead_of_main', '?')} ahead of main, {d.get('changed_files', '?')} changed files)",
]
rc = d.get("recent_commits") or []
if rc:
    lines.append("  recent commits:")
    lines += [f"    {c}" for c in rc]
print(json.dumps({"hookSpecificOutput": {
    "hookEventName": "SessionStart",
    "additionalContext": "\n".join(lines),
}}))
os.remove(p)  # one-shot: don't re-surface on later sessions
PY
exit 0
