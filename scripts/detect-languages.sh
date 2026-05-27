#!/usr/bin/env bash
# detect-languages.sh — scan a target repo and recommend which language packs to enable
# Usage: scripts/detect-languages.sh <repo-path>
set -euo pipefail

REPO="${1:?Usage: detect-languages.sh <repo-path>}"
[[ -d "${REPO}" ]] || { echo "ERROR: ${REPO} is not a directory." >&2; exit 1; }

python3 - "${REPO}" <<'PYEOF'
import sys, os

repo = sys.argv[1]

KNOWN_PACKS = ["python", "typescript", "sql", "infra"]

LANG_PATTERNS = {
    "python":     [".py", "pyproject.toml", "setup.py", "requirements.txt"],
    "typescript": [".ts", ".tsx", "tsconfig.json", "package.json"],
    "sql":        [".sql"],
    "infra":      [".yml", ".yaml", "Dockerfile"],
    "rust":       [".rs", "Cargo.toml"],
    "go":         [".go", "go.mod"],
    "ruby":       [".rb", "Gemfile"],
    "java":       [".java", "pom.xml"],
}

detected = set()

for dirpath, dirnames, filenames in os.walk(repo):
    # Skip hidden dirs and .git
    dirnames[:] = [d for d in dirnames if not d.startswith('.')]
    for fname in filenames:
        for lang, patterns in LANG_PATTERNS.items():
            for pat in patterns:
                if pat.startswith('.') and fname.endswith(pat):
                    detected.add(lang)
                elif fname == pat:
                    detected.add(lang)

print(f"=== Language detection for: {repo} ===\n")
print("Detected languages:")
for lang in sorted(detected):
    print(f"  {lang}")

print("\nRecommended language_packs_enabled:")
enabled = [l for l in KNOWN_PACKS if l in detected]
print(f"  [{', '.join(enabled)}]")

print("\nLanguages detected but WITHOUT a kit language pack:")
no_pack = sorted(l for l in detected if l not in KNOWN_PACKS)
if no_pack:
    for lang in no_pack:
        print(f"  {lang} — consider adding a language pack via docs/ADDING-A-LANGUAGE.md")
else:
    print("  (none)")
PYEOF
