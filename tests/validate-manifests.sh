#!/usr/bin/env bash
# validate-manifests.sh — plugin.json parses and declares the expected component dirs
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
FAIL=0

echo "=== Validating plugin.json ==="
PLUGIN_JSON="${REPO_ROOT}/.claude-plugin/plugin.json"
if [[ ! -f "$PLUGIN_JSON" ]]; then
  echo "FAIL [missing]: .claude-plugin/plugin.json" >&2
  FAIL=1
elif ! python3 -c "import json; json.load(open('${PLUGIN_JSON}'))" 2>/dev/null; then
  echo "FAIL [invalid JSON]: .claude-plugin/plugin.json" >&2
  FAIL=1
else
  echo "  plugin.json: valid JSON"
  for d in skills agents commands hooks; do
    if [[ -d "${REPO_ROOT}/${d}" ]]; then echo "  ${d}/: ok"; else echo "  WARN [component dir missing]: ${d}/" >&2; fi
  done
fi

if [[ "$FAIL" -eq 0 ]]; then echo "All manifests valid."; else echo "Manifest validation FAILED." >&2; exit 1; fi
