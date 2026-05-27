#!/usr/bin/env bash
# install-as-plugin.sh — install schnapp-kit as a local-path plugin for testing
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"

echo "Installing schnapp-kit as a local Claude Code plugin..."
echo "Plugin root: ${REPO_ROOT}"
echo ""
echo "Run this in the target repo:"
echo "  claude plugin install ${REPO_ROOT}"
echo ""
echo "Or in Claude Code chat: /plugin install ${REPO_ROOT}"
