#!/usr/bin/env bash
# render-merged-tree.sh — materialize the merged view of all layers into .merged-tree/
# Higher layers shadow lower layers by filename (basename match).
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
OUT="${REPO_ROOT}/.merged-tree"

rm -rf "${OUT}"
mkdir -p "${OUT}"

copy_layer() {
  local src="$1"
  [[ -d "${src}" ]] || return 0
  while IFS= read -r -d '' f; do
    local rel="${f#${src}/}"
    local basename
    basename=$(basename "${f}")
    local dest="${OUT}/${rel}"
    mkdir -p "$(dirname "${dest}")"
    cp "${f}" "${dest}"
  done < <(find "${src}" -type f -print0)
}

# Layers in ascending priority — later copies overwrite earlier ones
copy_layer "${REPO_ROOT}/core"
for d in "${REPO_ROOT}"/vendored/*/; do
  [[ -d "${d}" ]] || continue
  copy_layer "${d}"
done
for d in "${REPO_ROOT}"/language-packs/*/; do
  [[ -d "${d}" ]] || continue
  copy_layer "${d}"
done
copy_layer "${REPO_ROOT}/overlays"

TOTAL=$(find "${OUT}" -type f | wc -l | tr -d ' ')
echo "Merged tree written to .merged-tree/ (${TOTAL} files)."
