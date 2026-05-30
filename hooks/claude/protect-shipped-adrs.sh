#!/bin/bash
# PreToolUse(Edit|Write): enforce append-only ADR invariant.
# Shipped ADRs (already on HEAD) cannot be edited; supersede with a new ADR.
#
# Bypass: touch .claude/.allow-adr-edit (single-use, typo-grade corrections only).
# ADR path defaults to docs/decisions/. Projects using docs/adr/ work automatically
# because the pattern matches any docs/*/ADR-*.md path.

INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

if [[ -z "$FILE_PATH" ]]; then
  exit 0
fi

PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$(pwd)}"
case "$FILE_PATH" in
  /*) REL_PATH="${FILE_PATH#${PROJECT_DIR}/}" ;;
  *)  REL_PATH="$FILE_PATH" ;;
esac

# Match ADR-*.md files in any docs/ subdirectory (covers docs/decisions/ and docs/adr/).
case "$REL_PATH" in
  docs/*/ADR-*.md | docs/ADR-*.md) ;;
  *) exit 0 ;;
esac

if [[ "$(basename "$REL_PATH")" == "README.md" ]]; then
  exit 0
fi

# If not yet on HEAD, this is the initial author write — allowed.
if ! (cd "$PROJECT_DIR" && git cat-file -e "HEAD:$REL_PATH" 2>/dev/null); then
  exit 0
fi

BYPASS="${PROJECT_DIR}/.claude/.allow-adr-edit"
if [[ -f "$BYPASS" ]]; then
  rm -f "$BYPASS"
  echo "protect-shipped-adrs: bypass consumed for $REL_PATH" >&2
  exit 0
fi

cat >&2 <<EOF
protect-shipped-adrs: blocked edit to a shipped ADR.
File: $REL_PATH

ADRs are append-only. To revise a prior decision, write a new ADR with a
Supersedes: line pointing back. Use /skill adr-writer or the /adr command.

Typo-grade bypass (single-use):
  touch ${BYPASS}
then re-run.
EOF
exit 2
