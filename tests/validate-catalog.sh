#!/usr/bin/env bash
# validate-catalog.sh — docs/CATALOG.md is in sync with the generator.
# Regenerate with: python3 tests/gen-catalog.py
set -euo pipefail

DIR="$(cd "$(dirname "$0")" && pwd)"
echo "=== Validating docs/CATALOG.md freshness ==="
python3 "${DIR}/gen-catalog.py" --check
