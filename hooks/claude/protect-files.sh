#!/bin/bash
# PreToolUse(Edit|Write): block edits to commonly protected file patterns.
# Projects customize PROTECTED and ALLOWED lists in their local settings.json hooks config.

INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

# Files that look protected by name but are intentionally editable.
ALLOWED=(".env.template")
for allowed in "${ALLOWED[@]}"; do
  if [[ "$FILE_PATH" == *"$allowed"* ]]; then
    exit 0
  fi
done

# Patterns that should rarely be directly edited.
PROTECTED=(".env" "package-lock.json" ".git/")

for pattern in "${PROTECTED[@]}"; do
  if [[ "$FILE_PATH" == *"$pattern"* ]]; then
    echo "Blocked: $FILE_PATH matches protected pattern '$pattern'" >&2
    exit 2
  fi
done

exit 0
