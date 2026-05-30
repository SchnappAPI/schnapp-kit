#!/usr/bin/env bash
# SessionEnd: clean up transient per-session state. Side-effect only; SessionEnd
# cannot block, so always exit 0.
set -uo pipefail

cat >/dev/null 2>&1 || true  # drain stdin (SessionEnd payload, unused here)

PROJ="${CLAUDE_PROJECT_DIR:-$PWD}"
STATE_DIR="${HOME}/.claude/schnapp-kit"

# Remove the single-use destructive-guard bypass if a session left it behind.
rm -f "${PROJ}/.claude/.allow-destructive" 2>/dev/null || true

# GC old breadcrumbs + transcript backups (> 7 days). Fresh breadcrumbs survive
# so a compaction-triggered SessionStart can still consume them.
find "${STATE_DIR}" -maxdepth 1 -type f -name 'compaction-*.json' -mtime +7 -delete 2>/dev/null || true
find "${STATE_DIR}/transcripts" -type f -name '*.jsonl' -mtime +7 -delete 2>/dev/null || true

exit 0
