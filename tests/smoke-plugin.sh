#!/usr/bin/env bash
# smoke-plugin.sh — functional smoke test that mimics how Claude Code loads a
# plugin, then actually fires two guard hooks to prove they execute.
#
# Unlike the validate-*.sh structural checks, this exercises the discovery path
# end-to-end:
#   A. manifest        — .claude-plugin/plugin.json parses and names the plugin
#   B. skills          — every skills/<name>/SKILL.md has name+description, unique
#   C. agents          — every agents/*.md has name+description, unique
#   D. commands        — every commands/*.md parses; names unique
#   E. hook wiring     — every ${CLAUDE_PLUGIN_ROOT}/… path in hooks.json resolves
#   F. hooks fire      — run destructive-guard + no-commit-to-main for real and
#                        assert their exit codes (block vs allow)
set -uo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO_ROOT"
FAIL=0
pass() { echo "  ok   — $1"; }
fail() { echo "  FAIL — $1" >&2; FAIL=1; }
sec()  { echo; echo "=== $1 ==="; }

# Frontmatter helper: prints three lines — name, has_description(0/1),
# has_frontmatter(0/1) — reading only the block between the first two --- fences.
# Line-delimited (not tab) so an empty name doesn't collapse under IFS-whitespace.
fm() {
  python3 - "$1" <<'PY'
import sys
p = sys.argv[1]
lines = open(p, encoding="utf-8", errors="replace").read().splitlines()
if not lines or lines[0].strip() != "---":
    print(""); print(0); print(0); sys.exit(0)
name = ""; has_desc = 0
for ln in lines[1:]:
    if ln.strip() == "---":
        break
    if ln.startswith("name:"):
        name = ln.split(":", 1)[1].strip().strip('"').strip("'")
    elif ln.startswith("description:"):
        v = ln.split(":", 1)[1].strip()
        has_desc = 1 if v else 0
print(name); print(has_desc); print(1)
PY
}
# Read fm() output into fmname/hasdesc/hasfm for "$1".
read_fm() {
  mapfile -t _F < <(fm "$1")
  fmname="${_F[0]:-}"; hasdesc="${_F[1]:-0}"; hasfm="${_F[2]:-0}"
}

# ---------------------------------------------------------------------------
sec "A. Plugin manifest"
MANIFEST=".claude-plugin/plugin.json"
if [[ ! -f "$MANIFEST" ]]; then
  fail "$MANIFEST missing"
elif ! jq -e . "$MANIFEST" >/dev/null 2>&1; then
  fail "$MANIFEST is not valid JSON"
else
  NAME=$(jq -r '.name // empty' "$MANIFEST")
  [[ -n "$NAME" ]] && pass "manifest names plugin '$NAME'" || fail "manifest has no .name"
fi

# ---------------------------------------------------------------------------
sec "B. Skill discovery"
declare -A seen_skill
count=0
for d in skills/*/; do
  name="${d#skills/}"; name="${name%/}"
  smd="${d}SKILL.md"
  if [[ ! -f "$smd" ]]; then fail "skill '$name' has no SKILL.md"; continue; fi
  read_fm "$smd"
  if [[ "$hasfm" != 1 ]]; then fail "$smd: no frontmatter"; continue; fi
  [[ -n "$fmname" ]] || fail "$smd: frontmatter has no name"
  [[ "$hasdesc" == 1 ]] || fail "$smd: frontmatter has no description"
  # Claude Code identifies a plugin skill by its directory; the frontmatter
  # name must be the matching lowercase-hyphen slug.
  if [[ -n "$fmname" && "$fmname" != "$name" ]]; then
    fail "skill dir '$name' != frontmatter name '$fmname'"
  fi
  [[ "$name" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]] || fail "skill dir '$name' is not a valid slug"
  if [[ -n "$fmname" ]]; then
    [[ -n "${seen_skill[$fmname]:-}" ]] && fail "duplicate skill name '$fmname'"
    seen_skill[$fmname]=1
  fi
  count=$((count+1))
done
pass "$count skills discovered with valid frontmatter"

# ---------------------------------------------------------------------------
sec "C. Agent discovery"
declare -A seen_agent
count=0
for f in agents/*.md; do
  read_fm "$f"
  if [[ "$hasfm" != 1 ]]; then fail "$f: no frontmatter"; continue; fi
  [[ -n "$fmname" ]] || fail "$f: frontmatter has no name"
  [[ "$hasdesc" == 1 ]] || fail "$f: frontmatter has no description"
  if [[ -n "$fmname" ]]; then
    [[ -n "${seen_agent[$fmname]:-}" ]] && fail "duplicate agent name '$fmname'"
    seen_agent[$fmname]=1
  fi
  count=$((count+1))
done
pass "$count agents discovered with valid frontmatter"

# ---------------------------------------------------------------------------
sec "D. Command discovery"
declare -A seen_cmd
count=0
for f in commands/*.md; do
  base="$(basename "$f" .md)"
  read_fm "$f"
  # Frontmatter is optional for commands; name falls back to filename.
  cname="${fmname:-$base}"
  [[ -n "${seen_cmd[$cname]:-}" ]] && fail "duplicate command name '$cname'"
  seen_cmd[$cname]=1
  count=$((count+1))
done
pass "$count commands discovered (names unique)"

# ---------------------------------------------------------------------------
sec "E. Hook wiring resolves"
HJSON="hooks/hooks.json"
if ! jq -e . "$HJSON" >/dev/null 2>&1; then
  fail "$HJSON is not valid JSON"
else
  # Pull every command string, then every ${CLAUDE_PLUGIN_ROOT}/<path> token.
  mapfile -t paths < <(
    jq -r '.. | objects | .command? // empty' "$HJSON" \
    | grep -oE '\$\{CLAUDE_PLUGIN_ROOT\}/[^" ]+' \
    | sed 's#\${CLAUDE_PLUGIN_ROOT}/##' | sort -u
  )
  wired=0
  for rel in "${paths[@]}"; do
    if [[ ! -f "$REPO_ROOT/$rel" ]]; then
      fail "hooks.json references missing file: $rel"
    else
      if [[ "$rel" == *.sh ]]; then
        [[ -x "$REPO_ROOT/$rel" ]] || fail "$rel wired but not executable"
        head -1 "$REPO_ROOT/$rel" | grep -q '^#!' || fail "$rel wired but no shebang"
      fi
      wired=$((wired+1))
    fi
  done
  pass "$wired distinct hook paths in hooks.json all resolve"
fi

# ---------------------------------------------------------------------------
sec "F. Hooks actually fire"

# F1 — destructive-guard: block a destructive command, allow a benign one.
DG="hooks/claude/destructive-guard.sh"
out=$(echo '{"tool_input":{"command":"rm -rf /tmp/whatever"}}' | bash "$DG" 2>/dev/null); rc=$?
[[ $rc -eq 2 ]] && pass "destructive-guard blocks 'rm -rf' (exit 2)" \
                || fail "destructive-guard should block 'rm -rf' (got exit $rc)"
out=$(echo '{"tool_input":{"command":"ls -la"}}' | bash "$DG" 2>/dev/null); rc=$?
[[ $rc -eq 0 ]] && pass "destructive-guard allows 'ls' (exit 0)" \
                || fail "destructive-guard should allow 'ls' (got exit $rc)"

# F2 — no-commit-to-main: block git commit on main, allow on a feature branch.
# Run against a throwaway repo so the hook's `git rev-parse` sees a known branch.
NCM="$REPO_ROOT/hooks/claude/no-commit-to-main.sh"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
(
  cd "$TMP"
  git init -q -b main
  git config user.email t@t.t; git config user.name t
  # Disable signing/hooks so the throwaway commit doesn't touch the container's
  # signing server — we only need a born 'main' branch for rev-parse.
  git config commit.gpgsign false
  git config core.hooksPath /dev/null
  git commit -q --allow-empty -m init
  rc_block=0
  echo '{"tool_input":{"command":"git commit -m x"}}' | bash "$NCM" >/dev/null 2>&1 || rc_block=$?
  [[ $rc_block -eq 2 ]] && echo "  ok   — no-commit-to-main blocks commit on main (exit 2)" \
                        || { echo "  FAIL — no-commit-to-main should block on main (got exit $rc_block)" >&2; exit 1; }
  git checkout -q -b feat/x
  rc_allow=0
  echo '{"tool_input":{"command":"git commit -m x"}}' | bash "$NCM" >/dev/null 2>&1 || rc_allow=$?
  [[ $rc_allow -eq 0 ]] && echo "  ok   — no-commit-to-main allows commit on feature branch (exit 0)" \
                        || { echo "  FAIL — no-commit-to-main should allow on feature branch (got exit $rc_allow)" >&2; exit 1; }
) || FAIL=1

# ---------------------------------------------------------------------------
echo
if [[ "$FAIL" -eq 0 ]]; then
  echo "=== smoke-plugin: PASS ==="
else
  echo "=== smoke-plugin: FAIL ===" >&2
  exit 1
fi
