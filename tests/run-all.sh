#!/usr/bin/env bash
# run-all.sh — run all validators; exit nonzero if any fail
set -euo pipefail

DIR="$(cd "$(dirname "$0")" && pwd)"
FAIL=0

run() {
  local script="$1"
  echo ""
  echo ">>> $script"
  if bash "${DIR}/${script}"; then
    echo "    PASS"
  else
    echo "    FAIL" >&2
    FAIL=1
  fi
}

run validate-frontmatter.sh
run validate-hooks.sh
run validate-rules.sh
run validate-manifests.sh

echo ""
if [[ "$FAIL" -eq 0 ]]; then
  echo "=== All tests passed ==="
else
  echo "=== SOME TESTS FAILED ===" >&2
  exit 1
fi
