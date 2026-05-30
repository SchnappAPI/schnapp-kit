#!/usr/bin/env bash
# validate-frontmatter.sh — agents and skills have required YAML frontmatter fields
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
FAIL=0

check_frontmatter() {
  local file="$1"
  shift
  local required_fields=("$@")

  if ! head -1 "$file" | grep -q '^---'; then
    echo "FAIL [no frontmatter]: $file" >&2
    FAIL=1
    return
  fi

  for field in "${required_fields[@]}"; do
    # Extract frontmatter block (between first two --- delimiters)
    if ! awk 'BEGIN{p=0} /^---/{p++; next} p==1 && /^'"${field}"':/{found=1} p==2{exit} END{exit !found}' "$file" 2>/dev/null; then
      echo "FAIL [missing field '${field}']: $file" >&2
      FAIL=1
    fi
  done
}

echo "=== Validating agents frontmatter ==="
while IFS= read -r -d '' f; do
  check_frontmatter "$f" name description
done < <(find "${REPO_ROOT}/agents" -name "*.md" -print0 2>/dev/null)

echo "=== Validating skills frontmatter ==="
while IFS= read -r -d '' f; do
  check_frontmatter "$f" name description
done < <(find "${REPO_ROOT}/skills" -name "SKILL.md" -print0 2>/dev/null)

if [[ "$FAIL" -eq 0 ]]; then
  echo "All frontmatter valid."
else
  echo "Frontmatter validation FAILED." >&2
  exit 1
fi
