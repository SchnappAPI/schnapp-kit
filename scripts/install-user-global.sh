#!/usr/bin/env bash
# install-user-global.sh — materialize merged tree into ~/.claude/ via symlinks
# For Claude.ai web and Cowork surfaces (which don't support plugin discovery roots).
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TARGET="${HOME}/.claude"

echo "Rendering merged tree..."
"${REPO_ROOT}/scripts/render-merged-tree.sh"

MERGED="${REPO_ROOT}/.merged-tree"

echo "Installing into ${TARGET}..."
mkdir -p "${TARGET}"

for f in "${MERGED}"/*; do
  name=$(basename "${f}")
  dest="${TARGET}/${name}"
  if [[ -e "${dest}" && ! -L "${dest}" ]]; then
    echo "  SKIP (not a symlink, would overwrite user content): ${dest}"
    continue
  fi
  ln -sfn "${f}" "${dest}"
  echo "  linked: ${dest} -> ${f}"
done

echo "Done. ${TARGET} updated from schnapp-kit merged tree."
echo "Note: hooks are not active on Claude.ai web; only agents/skills/commands/rules are effective."
