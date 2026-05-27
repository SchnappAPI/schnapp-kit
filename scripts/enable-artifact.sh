#!/usr/bin/env bash
# enable-artifact.sh — toggle a single artifact glob in kit.config.yml
# Usage: scripts/enable-artifact.sh <upstream-name> <glob> [--disable]
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
UPSTREAM="${1:?Usage: enable-artifact.sh <upstream-name> <glob> [--disable]}"
GLOB="${2:?Usage: enable-artifact.sh <upstream-name> <glob> [--disable]}"
ACTION="${3:-enable}"

echo "Updating kit.config.yml: ${ACTION} ${GLOB} under vendored.${UPSTREAM}"
echo ""
echo "Manual step required: edit kit.config.yml and move:"
echo "  '${GLOB}'"
echo "from disabled_artifacts to enabled_artifacts (or vice-versa) under vendored.${UPSTREAM}."
echo ""
echo "After editing, run: scripts/conflict-check.sh"
