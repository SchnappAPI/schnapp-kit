#!/usr/bin/env bash
# validate-hooks.sh — every hook script is executable and has a shebang
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
FAIL=0

check_hook() {
  local f="$1"
  if [[ ! -x "$f" ]]; then
    echo "FAIL [not executable]: $f" >&2
    FAIL=1
  fi
  if ! head -1 "$f" | grep -q '^#!'; then
    echo "FAIL [missing shebang]: $f" >&2
    FAIL=1
  fi
}

echo "=== Validating hook scripts ==="
# Only .sh entrypoints must be executable+shebang'd. Imported .py modules
# (e.g. security-guidance helpers) and hooks.json data are not entrypoints.
while IFS= read -r -d '' f; do
  check_hook "$f"
done < <(find "${REPO_ROOT}/hooks" -type f -name '*.sh' -print0 2>/dev/null)

while IFS= read -r -d '' f; do
  check_hook "$f"
done < <(find "${REPO_ROOT}/.githooks" -type f -print0 2>/dev/null)

if [[ "$FAIL" -eq 0 ]]; then
  echo "All hooks valid."
else
  echo "Hook validation FAILED." >&2
  exit 1
fi
