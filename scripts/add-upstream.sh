#!/usr/bin/env bash
# add-upstream.sh — vendor a third-party plugin as a git subtree
# Usage: scripts/add-upstream.sh <name> <github-url> <pin>
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
NAME="${1:?Usage: add-upstream.sh <name> <github-url> <pin>}"
URL="${2:?Usage: add-upstream.sh <name> <github-url> <pin>}"
PIN="${3:?Usage: add-upstream.sh <name> <github-url> <pin>}"

TARGET="vendored/${NAME}"

if [[ -d "${REPO_ROOT}/${TARGET}" ]]; then
  echo "ERROR: ${TARGET} already exists. Use sync-upstream.sh to update." >&2
  exit 1
fi

echo "Adding upstream '${NAME}' from ${URL} @ ${PIN}..."

# Resolve pin to sha
TMP=$(mktemp -d)
git clone --depth=1 --branch "${PIN}" "${URL}" "${TMP}/${NAME}" 2>/dev/null || \
  git clone --depth=1 "${URL}" "${TMP}/${NAME}"
SHA=$(git -C "${TMP}/${NAME}" rev-parse HEAD)
SHORT=$(git -C "${TMP}/${NAME}" rev-parse --short HEAD)

echo "Resolved ${PIN} → ${SHA}"

# Copy tree (subtree-style without submodule)
mkdir -p "${REPO_ROOT}/${TARGET}"
rsync -a --exclude='.git' "${TMP}/${NAME}/" "${REPO_ROOT}/${TARGET}/"
rm -rf "${TMP}"

# Update vendored/.upstreams.yml
python3 - <<PYEOF
import re, datetime

path = "${REPO_ROOT}/vendored/.upstreams.yml"
content = open(path).read()

entry = """
  - name: ${NAME}
    source: ${URL}
    pin: ${PIN}
    pinned_commit: ${SHA}
    added: $(date -u +%Y-%m-%dT%H:%M:%SZ)
"""

if "upstreams: []" in content:
    content = content.replace("upstreams: []", "upstreams:" + entry)
else:
    content = content.rstrip() + entry

open(path, 'w').write(content)
print("Updated vendored/.upstreams.yml")
PYEOF

echo "Upstream '${NAME}' added at ${SHORT}."
echo "Next: update kit.config.yml vendored.${NAME}.pin to main@${SHA}, run scripts/conflict-check.sh"
