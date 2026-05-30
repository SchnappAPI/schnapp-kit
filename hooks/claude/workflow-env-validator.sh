#!/bin/bash
# PostToolUse(Edit|Write): lint .github/workflows/*.yml for env-block completeness.
# Non-blocking — emits warnings to stderr only.
#
# Required env vars are heuristically detected from workflow content.
# To add project-specific required vars, create .kit/workflow-required-envs.txt
# with one VAR_NAME:detection-pattern per line, e.g.:
#   MY_API_KEY:my-service|my_api
#
# Generalized from schnapp-bet's version: schnapp-specific var names replaced
# with configurable detection. Load from .kit/workflow-required-envs.txt if present.

INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

case "$FILE_PATH" in
  */.github/workflows/*.yml|*/.github/workflows/*.yaml) ;;
  *) exit 0 ;;
esac

WARN=()

# Per ADR-20260517-5 / rules/secrets.md: secrets must come from a secrets manager,
# not GitHub repo secrets directly. OP_SERVICE_ACCOUNT_TOKEN and GITHUB_TOKEN are
# the only allowed exceptions.
if grep -qE 'secrets\.[A-Z_]+' "$FILE_PATH"; then
  if grep -qE 'secrets\.(?!OP_SERVICE_ACCOUNT_TOKEN|GITHUB_TOKEN)[A-Z_]+' "$FILE_PATH" 2>/dev/null || \
     grep -oE 'secrets\.[A-Z_]+' "$FILE_PATH" | grep -vE 'secrets\.(OP_SERVICE_ACCOUNT_TOKEN|GITHUB_TOKEN)' | grep -q .; then
    WARN+=("uses secrets.* directly — use a secrets manager action (e.g. 1password/load-secrets-action@v2) with op:// URIs instead")
  fi
fi

# Load project-specific required env checks from .kit/workflow-required-envs.txt
KIT_ENVS="${CLAUDE_PROJECT_DIR:-$(pwd)}/.kit/workflow-required-envs.txt"
if [[ -f "$KIT_ENVS" ]]; then
  while IFS=: read -r var_name detect_pattern; do
    [[ -z "$var_name" || "$var_name" =~ ^# ]] && continue
    if grep -qE "$detect_pattern" "$FILE_PATH"; then
      if ! grep -qE "(^|[^A-Z_])${var_name}:" "$FILE_PATH"; then
        WARN+=("missing env var ${var_name} (workflow matches pattern: ${detect_pattern})")
      fi
    fi
  done < "$KIT_ENVS"
fi

if [[ ${#WARN[@]} -gt 0 ]]; then
  echo "workflow-env-validator: $FILE_PATH" >&2
  for w in "${WARN[@]}"; do
    echo "  warn: $w" >&2
  done
fi

exit 0
