#!/usr/bin/env bash
# conflict-check.sh — walk all layers, report duplicate artifact names across layers
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"

declare -A NAME_TO_PATHS

add_artifacts() {
  local layer="$1"
  local dir="${REPO_ROOT}/${layer}"
  [[ -d "${dir}" ]] || return 0

  while IFS= read -r -d '' f; do
    local basename
    basename=$(basename "${f}")
    local rel="${f#${REPO_ROOT}/}"

    if [[ -n "${NAME_TO_PATHS[${basename}]+_}" ]]; then
      NAME_TO_PATHS["${basename}"]="${NAME_TO_PATHS[${basename}]}|${rel}"
    else
      NAME_TO_PATHS["${basename}"]="${rel}"
    fi
  done < <(find "${dir}" -type f \( -name "*.md" -o -name "*.sh" -o -name "*.json" -o -name "*.yml" \) -print0)
}

add_artifacts "core"
for d in "${REPO_ROOT}"/vendored/*/; do
  [[ -d "${d}" ]] || continue
  layer="vendored/$(basename "${d}")"
  add_artifacts "${layer}"
done
for d in "${REPO_ROOT}"/language-packs/*/; do
  [[ -d "${d}" ]] || continue
  layer="language-packs/$(basename "${d}")"
  add_artifacts "${layer}"
done
add_artifacts "overlays"

CONFLICTS=0
echo "=== Conflict check ==="
for name in "${!NAME_TO_PATHS[@]}"; do
  paths="${NAME_TO_PATHS[${name}]}"
  count=$(echo "${paths}" | tr '|' '\n' | wc -l | tr -d ' ')
  if [[ "${count}" -gt 1 ]]; then
    echo ""
    echo "SHADOW: ${name}"
    echo "${paths}" | tr '|' '\n' | while read -r p; do
      echo "  ${p}"
    done
    CONFLICTS=$((CONFLICTS + 1))
  fi
done

echo ""
if [[ "${CONFLICTS}" -eq 0 ]]; then
  echo "No conflicts found."
else
  echo "${CONFLICTS} artifact name(s) appear in multiple layers."
  echo "Shadows in overlays/ are intentional — ensure each has an entry in overlays/SHADOWS.md."
fi
