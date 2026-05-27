#!/usr/bin/env bash
# validate-manifests.sh — plugin.json and kit.config.yml parse and reference existing paths
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
FAIL=0

echo "=== Validating plugin.json ==="
PLUGIN_JSON="${REPO_ROOT}/.claude-plugin/plugin.json"
if [[ ! -f "$PLUGIN_JSON" ]]; then
  echo "FAIL [missing]: .claude-plugin/plugin.json" >&2
  FAIL=1
else
  if ! python3 -c "import json; json.load(open('${PLUGIN_JSON}'))" 2>/dev/null; then
    echo "FAIL [invalid JSON]: .claude-plugin/plugin.json" >&2
    FAIL=1
  else
    echo "  plugin.json: valid JSON"
    python3 - "${REPO_ROOT}" "${PLUGIN_JSON}" <<'PYEOF'
import json, sys, os
repo, manifest = sys.argv[1], sys.argv[2]
data = json.load(open(manifest))
roots = data.get("discoveryRoots", [])
for root in roots:
    path = os.path.join(repo, root)
    if not os.path.isdir(path):
        print(f"  WARN [discoveryRoot missing on disk]: {root}", file=sys.stderr)
    else:
        print(f"  discoveryRoot '{root}': ok")
PYEOF
  fi
fi

echo "=== Validating kit.config.yml ==="
KIT_CONFIG="${REPO_ROOT}/kit.config.yml"
if [[ ! -f "$KIT_CONFIG" ]]; then
  echo "FAIL [missing]: kit.config.yml" >&2
  FAIL=1
else
  # Try PyYAML first; fall back to basic checks if not available
  if python3 -c "import yaml" 2>/dev/null; then
    if python3 -c "import yaml; yaml.safe_load(open('${KIT_CONFIG}'))" 2>/dev/null; then
      echo "  kit.config.yml: valid YAML"
    else
      echo "FAIL [invalid YAML]: kit.config.yml" >&2
      FAIL=1
    fi
  else
    # Basic checks: file is non-empty, has expected keys
    if [[ -s "$KIT_CONFIG" ]] && grep -q '^core:' "$KIT_CONFIG" && grep -q '^vendored:' "$KIT_CONFIG"; then
      echo "  kit.config.yml: basic structure ok (PyYAML not available for full parse)"
    else
      echo "FAIL [missing expected keys in kit.config.yml]" >&2
      FAIL=1
    fi
  fi
fi

if [[ "$FAIL" -eq 0 ]]; then
  echo "All manifests valid."
else
  echo "Manifest validation FAILED." >&2
  exit 1
fi
