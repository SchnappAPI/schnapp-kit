#!/usr/bin/env bash
# promote-from-project.sh — copy a project-local artifact into overlays/
# Usage: scripts/promote-from-project.sh <source-path> --type <agent|skill|command|hook|rule> --name <slug>
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"

SOURCE="${1:?Usage: promote-from-project.sh <source-path> --type <kind> --name <slug>}"
shift

TYPE=""
NAME=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --type) TYPE="$2"; shift 2 ;;
    --name) NAME="$2"; shift 2 ;;
    *) echo "Unknown flag: $1" >&2; exit 1 ;;
  esac
done

[[ -n "${TYPE}" ]] || { echo "ERROR: --type required" >&2; exit 1; }
[[ -n "${NAME}" ]] || { echo "ERROR: --name required" >&2; exit 1; }
[[ -e "${SOURCE}" ]] || { echo "ERROR: source not found: ${SOURCE}" >&2; exit 1; }

case "${TYPE}" in
  agent)   DEST="${REPO_ROOT}/overlays/agents/${NAME}.md" ;;
  skill)   DEST="${REPO_ROOT}/overlays/skills/${NAME}" ;;
  command) DEST="${REPO_ROOT}/overlays/commands/${NAME}.md" ;;
  hook)    DEST="${REPO_ROOT}/overlays/hooks/claude/${NAME}.sh" ;;
  rule)    DEST="${REPO_ROOT}/overlays/rules/${NAME}.md" ;;
  *)       echo "ERROR: unknown type ${TYPE}" >&2; exit 1 ;;
esac

if [[ -d "${SOURCE}" ]]; then
  cp -r "${SOURCE}" "${DEST}"
else
  mkdir -p "$(dirname "${DEST}")"
  cp "${SOURCE}" "${DEST}"
fi

echo "Promoted: ${SOURCE} → ${DEST}"
echo "Running conflict-check..."
"${REPO_ROOT}/scripts/conflict-check.sh"
echo "Running tests..."
"${REPO_ROOT}/tests/run-all.sh" || echo "WARNING: tests failed — review before committing."
echo ""
echo "Review ${DEST}, then commit: feat: [overlays] promote ${NAME} from project"
