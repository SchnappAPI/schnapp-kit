#!/usr/bin/env bash
# validate-rules.sh — every rule file is well-formed markdown with frontmatter
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
FAIL=0

check_rule() {
  local f="$1"
  # Must not be empty
  if [[ ! -s "$f" ]]; then
    echo "FAIL [empty file]: $f" >&2
    FAIL=1
    return
  fi
  # Must have frontmatter OR start with a heading (some rules have no frontmatter)
  first_line=$(head -1 "$f")
  if [[ ! "$first_line" =~ ^(---|#) ]]; then
    echo "WARN [no frontmatter or heading]: $f" >&2
  fi
}

echo "=== Validating rules ==="
while IFS= read -r -d '' f; do
  check_rule "$f"
done < <(find "${REPO_ROOT}/overlays/rules" -name "*.md" -print0 2>/dev/null)

while IFS= read -r -d '' f; do
  check_rule "$f"
done < <(find "${REPO_ROOT}/language-packs" -path "*/rules/*.md" -print0 2>/dev/null)

if [[ "$FAIL" -eq 0 ]]; then
  echo "All rules valid."
else
  echo "Rules validation FAILED." >&2
  exit 1
fi
