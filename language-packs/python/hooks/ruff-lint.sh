#!/bin/bash
# PostToolUse(Edit|Write): lint Python edits with ruff via uvx (no install required).
# Non-blocking — warns but does not block.

INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

case "$FILE_PATH" in
  *.py) ;;
  *) exit 0 ;;
esac

if ! command -v uvx >/dev/null 2>&1; then
  exit 0
fi

uvx ruff check --fix --quiet "$FILE_PATH" 2>&1 || true
uvx ruff format --quiet "$FILE_PATH" 2>&1 || true
exit 0
