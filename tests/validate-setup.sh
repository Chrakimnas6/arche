#!/usr/bin/env bash

set -euo pipefail

cd "$(dirname "$0")/.."

PASS=0
FAIL=0

pass() { PASS=$((PASS + 1)); printf "  \033[32m✓\033[0m %s\n" "$1"; }
fail() { FAIL=$((FAIL + 1)); printf "  \033[31m✗\033[0m %s\n" "$1"; }
section() { printf "\n\033[1m%s\033[0m\n" "$1"; }

section "Skills"

for dir in .agents/skills/*/; do
  skill=$(basename "$dir")
  file="$dir/SKILL.md"
  if [ ! -f "$file" ]; then
    fail "$skill: no SKILL.md"
  elif [ "$(head -1 "$file")" != "---" ]; then
    fail "$skill: no YAML frontmatter"
  elif ! grep -qx "name: $skill" "$file"; then
    fail "$skill: frontmatter name does not match the directory"
  elif ! grep -q '^description:' "$file"; then
    fail "$skill: no description"
  else
    pass "$skill"
  fi
done

section "Agents"

for file in .agents/agents/*.md; do
  agent=$(basename "$file" .md)
  missing=""
  for field in name description model; do
    grep -q "^$field:" "$file" || missing="$missing $field"
  done
  [ -z "$missing" ] && pass "$agent" || fail "$agent: missing$missing"
done

section "Layout"

if [ "$(readlink .claude/skills 2>/dev/null)" = "../.agents/skills" ] && [ -e .claude/skills ]; then
  pass ".claude/skills -> ../.agents/skills"
else
  fail ".claude/skills must be a symlink to ../.agents/skills that resolves"
fi

# Claude Code reads AGENTS.md only when the project has no CLAUDE.md.
for f in CLAUDE.md .claude/CLAUDE.md; do
  [ -e "$f" ] && fail "$f exists, so Claude Code would skip AGENTS.md" || pass "no $f shadowing AGENTS.md"
done

for f in .claude/settings.json .github/upstream-shas.json; do
  python3 -c "import json, sys; json.load(open(sys.argv[1]))" "$f" 2>/dev/null \
    && pass "$f is valid JSON" || fail "$f is not valid JSON"
done

section "Upstream credits"

for repo in $(python3 -c "import json; print('\n'.join(json.load(open('.github/upstream-shas.json'))))"); do
  grep -q "$repo" README.md && pass "README names $repo" || fail "README does not name tracked repo $repo"
done

printf "\n\033[1m%d passed, %d failed\033[0m\n" "$PASS" "$FAIL"
[ "$FAIL" -eq 0 ]
