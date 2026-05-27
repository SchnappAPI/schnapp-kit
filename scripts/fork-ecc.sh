#!/usr/bin/env bash
# fork-ecc.sh — clone ECC at a pinned commit, copy into core/, write ATTRIBUTION.md
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
ECC_URL="https://github.com/affaan-m/ECC"
ECC_TMP="$(mktemp -d)"

echo "Cloning ECC from ${ECC_URL}..."
git clone --depth=1 "${ECC_URL}" "${ECC_TMP}/ecc"

ECC_SHA=$(git -C "${ECC_TMP}/ecc" rev-parse HEAD)
ECC_SHORT=$(git -C "${ECC_TMP}/ecc" rev-parse --short HEAD)
echo "Pinned at: ${ECC_SHA}"

echo "Copying tree into core/..."
rm -rf "${REPO_ROOT}/core"
mkdir -p "${REPO_ROOT}/core"
# Copy everything except .git
rsync -a --exclude='.git' "${ECC_TMP}/ecc/" "${REPO_ROOT}/core/"

# Write attribution
cat > "${REPO_ROOT}/core/ATTRIBUTION.md" <<EOF
# Attribution — core/ layer

The \`core/\` directory is a fork of [affaan-m/ECC](https://github.com/affaan-m/ECC).

- **Source**: ${ECC_URL}
- **Pinned commit**: ${ECC_SHA}
- **Forked**: $(date -u +%Y-%m-%dT%H:%M:%SZ)
- **License**: see upstream LICENSE file

## What changed after forking

Language packs for unused languages were pruned (see \`scripts/prune-languages.sh\` and \`kit.config.yml.core.pruned_languages\`). No other modifications to the upstream tree — all examples, output styles, statuslines, workflow templates, MCP server templates, and cross-cutting agents/skills/commands are kept intact.

To re-sync: \`scripts/sync-upstream.sh core\`
EOF

# Write sha to a temp file for the caller to pick up
echo "${ECC_SHA}" > "${REPO_ROOT}/.ecc-sha"
echo "${ECC_SHORT}" > "${REPO_ROOT}/.ecc-short-sha"

rm -rf "${ECC_TMP}"

echo "Done. ECC forked at ${ECC_SHORT} into core/."
echo "Next: run scripts/prune-languages.sh, then update kit.config.yml core.pinned_commit to ${ECC_SHA}"
