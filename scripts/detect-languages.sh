#!/usr/bin/env bash
# detect-languages.sh — scan a target repo and recommend which language packs to enable
# Usage: scripts/detect-languages.sh <repo-path>
set -euo pipefail

REPO="${1:?Usage: detect-languages.sh <repo-path>}"
[[ -d "${REPO}" ]] || { echo "ERROR: ${REPO} is not a directory." >&2; exit 1; }

declare -A DETECTED

detect() {
  local lang="$1"; shift
  local found=0
  for pattern in "$@"; do
    if find "${REPO}" -name "${pattern}" -not -path '*/.git/*' -maxdepth 6 | grep -q .; then
      found=1; break
    fi
  done
  [[ "${found}" -eq 1 ]] && DETECTED["${lang}"]=1
}

detect "python"     "*.py" "pyproject.toml" "setup.py" "requirements*.txt"
detect "typescript" "*.ts" "*.tsx" "tsconfig.json" "package.json"
detect "sql"        "*.sql" "*.mdf" "*.bak"
detect "infra"      "*.yml" "Dockerfile" "*.yaml" ".github"
detect "rust"       "*.rs" "Cargo.toml"
detect "go"         "*.go" "go.mod"
detect "ruby"       "*.rb" "Gemfile"
detect "java"       "*.java" "pom.xml" "build.gradle"

KNOWN_PACKS=(python typescript sql infra)

echo "=== Language detection for: ${REPO} ==="
echo ""
echo "Detected languages:"
for lang in "${!DETECTED[@]}"; do
  echo "  ${lang}"
done
echo ""
echo "Recommended language_packs_enabled:"
ENABLED=()
for lang in "${KNOWN_PACKS[@]}"; do
  [[ -n "${DETECTED[${lang}]+_}" ]] && ENABLED+=("${lang}")
done
echo "  [$(IFS=', '; echo "${ENABLED[*]}")]"
echo ""
echo "Languages detected but WITHOUT a kit language pack:"
for lang in "${!DETECTED[@]}"; do
  found=0
  for k in "${KNOWN_PACKS[@]}"; do [[ "${k}" == "${lang}" ]] && found=1; done
  [[ "${found}" -eq 0 ]] && echo "  ${lang} — consider adding a language pack via docs/ADDING-A-LANGUAGE.md"
done
