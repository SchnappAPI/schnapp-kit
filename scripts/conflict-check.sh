#!/usr/bin/env bash
# conflict-check.sh — walk all layers, report duplicate artifact names across layers
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"

python3 - "${REPO_ROOT}" <<'PYEOF'
import sys, os, collections

repo = sys.argv[1]
layers = []

def add_layer(path):
    if os.path.isdir(path):
        layers.append(path)

add_layer(os.path.join(repo, "core"))
vendored = os.path.join(repo, "vendored")
if os.path.isdir(vendored):
    for name in sorted(os.listdir(vendored)):
        d = os.path.join(vendored, name)
        if os.path.isdir(d) and not name.startswith('.'):
            add_layer(d)
lang_packs = os.path.join(repo, "language-packs")
if os.path.isdir(lang_packs):
    for name in sorted(os.listdir(lang_packs)):
        d = os.path.join(lang_packs, name)
        if os.path.isdir(d):
            add_layer(d)
add_layer(os.path.join(repo, "overlays"))

name_to_paths = collections.defaultdict(list)
for layer_root in layers:
    for dirpath, dirnames, filenames in os.walk(layer_root):
        for fname in filenames:
            if fname.startswith('.'):
                continue
            if not any(fname.endswith(ext) for ext in ('.md', '.sh', '.json', '.yml', '.yaml')):
                continue
            full = os.path.join(dirpath, fname)
            rel = os.path.relpath(full, repo)
            name_to_paths[fname].append(rel)

conflicts = 0
print("=== Conflict check ===")
for name, paths in sorted(name_to_paths.items()):
    if len(paths) > 1:
        print(f"\nSHADOW: {name}")
        for p in paths:
            print(f"  {p}")
        conflicts += 1

print()
if conflicts == 0:
    print("No conflicts found.")
else:
    print(f"{conflicts} artifact name(s) appear in multiple layers.")
    print("Shadows in overlays/ are intentional — ensure each has an entry in overlays/SHADOWS.md.")
PYEOF
