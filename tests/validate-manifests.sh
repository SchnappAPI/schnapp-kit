#!/usr/bin/env bash
# validate-manifests.sh — plugin.json / marketplace.json / .mcp.json parse and
# the expected component dirs exist.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
FAIL=0

is_json() { python3 -c "import json,sys; json.load(open(sys.argv[1]))" "$1" 2>/dev/null; }

echo "=== Validating plugin.json ==="
PLUGIN_JSON="${REPO_ROOT}/.claude-plugin/plugin.json"
if [[ ! -f "$PLUGIN_JSON" ]]; then
  echo "FAIL [missing]: .claude-plugin/plugin.json" >&2
  FAIL=1
elif ! is_json "$PLUGIN_JSON"; then
  echo "FAIL [invalid JSON]: .claude-plugin/plugin.json" >&2
  FAIL=1
else
  echo "  plugin.json: valid JSON"
  for d in skills agents commands hooks; do
    if [[ -d "${REPO_ROOT}/${d}" ]]; then echo "  ${d}/: ok"; else echo "  WARN [component dir missing]: ${d}/" >&2; fi
  done
fi

echo "=== Validating marketplace.json ==="
MARKET_JSON="${REPO_ROOT}/.claude-plugin/marketplace.json"
if [[ -f "$MARKET_JSON" ]]; then
  if ! is_json "$MARKET_JSON"; then
    echo "FAIL [invalid JSON]: .claude-plugin/marketplace.json" >&2; FAIL=1
  else
    echo "  marketplace.json: valid JSON"
    # Regression guard: the install surface must not describe the pre-flatten
    # layered model (this exact drift slipped past the flatten once).
    if grep -qiE 'overlays|ECC fork|layered (claude|distribution)' "$MARKET_JSON"; then
      echo "FAIL [stale text]: marketplace.json still describes the pre-flatten layered model" >&2; FAIL=1
    fi
  fi
fi

echo "=== Validating .mcp.json (if present) ==="
MCP_JSON="${REPO_ROOT}/.mcp.json"
if [[ -f "$MCP_JSON" ]]; then
  if ! python3 -c "import json,sys; d=json.load(open(sys.argv[1])); sys.exit(0 if isinstance(d.get('mcpServers'),dict) else 1)" "$MCP_JSON" 2>/dev/null; then
    echo "FAIL [invalid .mcp.json or missing mcpServers object]: .mcp.json" >&2; FAIL=1
  else
    echo "  .mcp.json: valid JSON with mcpServers"
  fi
fi

if [[ "$FAIL" -eq 0 ]]; then echo "All manifests valid."; else echo "Manifest validation FAILED." >&2; exit 1; fi
