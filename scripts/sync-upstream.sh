#!/usr/bin/env bash
# sync-upstream.sh — bump pin and re-copy one or all vendored upstreams
# Usage: scripts/sync-upstream.sh <name|--all>
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TARGET="${1:?Usage: sync-upstream.sh <name|--all>}"

sync_one() {
  local name="$1"
  local dir="${REPO_ROOT}/vendored/${name}"

  if [[ "${name}" == "core" ]]; then
    echo "Re-forking ECC into core/..."
    "${REPO_ROOT}/scripts/fork-ecc.sh"
    "${REPO_ROOT}/scripts/prune-languages.sh"
    return
  fi

  [[ -d "${dir}" ]] || { echo "ERROR: vendored/${name} not found." >&2; exit 1; }

  # Read source URL from .upstreams.yml
  URL=$(python3 -c "
import re
content = open('${REPO_ROOT}/vendored/.upstreams.yml').read()
m = re.search(r'name: ${name}\n.*?source: (\S+)', content, re.DOTALL)
if m: print(m.group(1))
" 2>/dev/null || echo "")

  if [[ -z "${URL}" ]]; then
    echo "ERROR: ${name} not found in vendored/.upstreams.yml" >&2
    exit 1
  fi

  echo "Syncing ${name} from ${URL}..."
  TMP=$(mktemp -d)
  git clone --depth=1 "${URL}" "${TMP}/${name}"
  SHA=$(git -C "${TMP}/${name}" rev-parse HEAD)
  SHORT=$(git -C "${TMP}/${name}" rev-parse --short HEAD)

  rm -rf "${dir}"
  mkdir -p "${dir}"
  rsync -a --exclude='.git' "${TMP}/${name}/" "${dir}/"
  rm -rf "${TMP}"

  echo "  ${name} updated to ${SHORT} (${SHA})"
}

if [[ "${TARGET}" == "--all" ]]; then
  sync_one "core"
  for d in "${REPO_ROOT}"/vendored/*/; do
    [[ -d "${d}" ]] || continue
    name=$(basename "${d}")
    sync_one "${name}"
  done
else
  sync_one "${TARGET}"
fi

echo "Running conflict-check..."
"${REPO_ROOT}/scripts/conflict-check.sh"
echo "Running tests..."
"${REPO_ROOT}/tests/run-all.sh" || echo "WARNING: some tests failed. Review before committing."
