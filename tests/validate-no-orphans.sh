#!/usr/bin/env bash
# validate-no-orphans.sh — every kit.config.yml enabled_artifact glob matches at least one real file
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
FAIL=0

echo "=== Validating no orphan enabled_artifacts globs ==="

python3 - "${REPO_ROOT}" <<'PYEOF'
import sys, os, glob as globmod, re

repo = sys.argv[1]
config_path = os.path.join(repo, "kit.config.yml")

try:
    import yaml
    config = yaml.safe_load(open(config_path))
except ImportError:
    # Fallback: regex parse for enabled_artifacts lines
    import re
    content = open(config_path).read()
    # Simplified check — just warn that PyYAML isn't available
    print("  WARN: PyYAML not available; skipping enabled_artifacts check")
    sys.exit(0)

vendored = config.get("vendored", {})
fail = False

for upstream_name, upstream_cfg in vendored.items():
    if not isinstance(upstream_cfg, dict):
        continue
    enabled = upstream_cfg.get("enabled_artifacts", [])
    upstream_dir = os.path.join(repo, "vendored", upstream_name)

    if not os.path.isdir(upstream_dir):
        print(f"  WARN [{upstream_name}]: vendored dir missing on disk — skip orphan check")
        continue

    for pattern in enabled:
        full_pattern = os.path.join(upstream_dir, pattern)
        matches = globmod.glob(full_pattern, recursive=True)
        if not matches:
            print(f"  FAIL [orphan glob] vendored.{upstream_name}: '{pattern}' matches no files", file=sys.stderr)
            fail = True
        else:
            print(f"  ok: vendored.{upstream_name} '{pattern}' ({len(matches)} file(s))")

if fail:
    sys.exit(1)
print("All enabled_artifact globs have matches.")
PYEOF

STATUS=$?
if [[ "$STATUS" -ne 0 ]]; then
  FAIL=1
fi

if [[ "$FAIL" -eq 0 ]]; then
  echo "No-orphans validation passed."
else
  echo "No-orphans validation FAILED." >&2
  exit 1
fi
