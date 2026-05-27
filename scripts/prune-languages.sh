#!/usr/bin/env bash
# prune-languages.sh — remove pruned-language files from core/ after fork
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
CORE="${REPO_ROOT}/core"

if [[ ! -d "${CORE}" ]]; then
  echo "ERROR: core/ does not exist. Run scripts/fork-ecc.sh first." >&2
  exit 1
fi

PRUNED_DIRS=(java ruby go rust php csharp kotlin swift scala elixir erlang clojure haskell ocaml fsharp dart lua perl)
PRUNED_EXTS=(java rb go rs php cs kt swift scala exs ex erl clj hs ml fs dart lua r pl)

echo "Pruning language-specific directories..."
for lang in "${PRUNED_DIRS[@]}"; do
  find "${CORE}" -type d -name "${lang}" | while read -r dir; do
    echo "  rm -rf ${dir}"
    rm -rf "${dir}"
  done
done

echo "Pruning language-specific example files..."
for ext in "${PRUNED_EXTS[@]}"; do
  find "${CORE}/examples" -type f -name "*.${ext}" 2>/dev/null | while read -r f; do
    echo "  rm ${f}"
    rm "${f}"
  done
done

echo "Pruning agents/skills with pruned language: in frontmatter..."
for lang in "${PRUNED_DIRS[@]}"; do
  grep -rl "^language: ${lang}" "${CORE}" 2>/dev/null | while read -r f; do
    echo "  rm ${f} (language: ${lang})"
    rm "${f}"
  done
done

TOTAL=$(find "${CORE}" -type f | wc -l | tr -d ' ')
EXAMPLES=$(find "${CORE}/examples" -type f 2>/dev/null | wc -l | tr -d ' ')
echo ""
echo "Pruning complete."
echo "  Files remaining in core/: ${TOTAL}"
echo "  Example files remaining: ${EXAMPLES}"
