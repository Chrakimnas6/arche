#!/usr/bin/env bash
# Validates the vibe-coding-setup template is consistent and complete.
# Run from the repo root: bash tests/validate-setup.sh

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO_ROOT"

PASS=0
FAIL=0

pass() { PASS=$((PASS + 1)); printf "  \033[32m✓\033[0m %s\n" "$1"; }
fail() { FAIL=$((FAIL + 1)); printf "  \033[31m✗\033[0m %s\n" "$1"; }
section() { printf "\n\033[1m%s\033[0m\n" "$1"; }

# ---------------------------------------------------------------------------
section "1. Core files exist"
# ---------------------------------------------------------------------------

for f in \
  AGENTS.md \
  README.md \
  .codex/config.toml \
  .claude/settings.json \
  .agents/hooks/check-careful.sh \
  docs/principles/index.md \
  global/CLAUDE.md \
  .github/workflows/ci.yml \
  .github/upstream-shas.json; do
  [ -f "$f" ] && pass "$f" || fail "$f missing"
done

# ---------------------------------------------------------------------------
section "2. Skills structure"
# ---------------------------------------------------------------------------

EXPECTED_SKILLS="adversarial-review careful grill-me investigate plan reflect review tdd"

for skill in $EXPECTED_SKILLS; do
  skill_file=".agents/skills/$skill/SKILL.md"
  [ -f "$skill_file" ] && pass "$skill_file" || fail "$skill_file missing"
done

# Adversarial-review references
for ref in reviewer-lenses.md verdict-format.md; do
  f=".agents/skills/adversarial-review/references/$ref"
  [ -f "$f" ] && pass "$ref exists" || fail "$ref missing"
done

# reviewer-prompt.md should NOT exist (inlined into SKILL.md)
if [ ! -f ".agents/skills/adversarial-review/references/reviewer-prompt.md" ]; then
  pass "reviewer-prompt.md correctly removed"
else
  fail "reviewer-prompt.md should not exist (was inlined into SKILL.md)"
fi

# TDD references
for ref in testing-anti-patterns.md mocking.md; do
  f=".agents/skills/tdd/references/$ref"
  [ -f "$f" ] && pass "tdd/$ref" || fail "tdd/$ref missing"
done

# Investigate references
for ref in root-cause-tracing.md defense-in-depth.md condition-based-waiting.md; do
  f=".agents/skills/investigate/references/$ref"
  [ -f "$f" ] && pass "investigate/$ref" || fail "investigate/$ref missing"
done

# ---------------------------------------------------------------------------
section "3. Symlinks"
# ---------------------------------------------------------------------------

check_symlink() {
  local link="$1" target="$2"
  if [ -L "$link" ]; then
    actual=$(readlink "$link")
    if [ "$actual" = "$target" ]; then
      pass "$link -> $target"
    else
      fail "$link points to '$actual', expected '$target'"
    fi
  else
    fail "$link is not a symlink"
  fi
}

check_symlink ".claude/CLAUDE.md" "../AGENTS.md"
check_symlink ".claude/hooks" "../.agents/hooks"
check_symlink ".claude/skills" "../.agents/skills"

# Verify symlink targets actually resolve
for link in .claude/CLAUDE.md .claude/hooks .claude/skills; do
  [ -e "$link" ] && pass "$link resolves" || fail "$link is a broken symlink"
done

# ---------------------------------------------------------------------------
section "4. Skill frontmatter"
# ---------------------------------------------------------------------------

for skill in $EXPECTED_SKILLS; do
  skill_file=".agents/skills/$skill/SKILL.md"
  [ ! -f "$skill_file" ] && continue

  # Check for YAML frontmatter delimiters
  first_line=$(head -1 "$skill_file")
  if [ "$first_line" = "---" ]; then
    # Check name field exists
    if grep -q '^name:' "$skill_file"; then
      pass "$skill: has name field"
    else
      fail "$skill: missing name field in frontmatter"
    fi
    # Check description field exists
    if grep -q '^description:' "$skill_file"; then
      pass "$skill: has description field"
    else
      fail "$skill: missing description field in frontmatter"
    fi
  else
    fail "$skill: missing YAML frontmatter (first line should be ---)"
  fi
done

# ---------------------------------------------------------------------------
section "5. Valid JSON/TOML config"
# ---------------------------------------------------------------------------

# settings.json
if python3 -c "import json; json.load(open('.claude/settings.json'))" 2>/dev/null; then
  pass "settings.json is valid JSON"
else
  fail "settings.json is invalid JSON"
fi

# config.toml — basic check (model key exists)
if grep -q '^model' .codex/config.toml; then
  pass "config.toml has model key"
else
  fail "config.toml missing model key"
fi

# upstream-shas.json
if python3 -c "import json; json.load(open('.github/upstream-shas.json'))" 2>/dev/null; then
  pass "upstream-shas.json is valid JSON"
else
  fail "upstream-shas.json is invalid JSON"
fi

# ---------------------------------------------------------------------------
section "6. Hook executable"
# ---------------------------------------------------------------------------

if [ -x ".agents/hooks/check-careful.sh" ]; then
  pass "check-careful.sh is executable"
else
  fail "check-careful.sh is not executable"
fi

# ---------------------------------------------------------------------------
section "7. No stale references"
# ---------------------------------------------------------------------------

# No remaining references to reviewer-prompt.md
if grep -r "reviewer-prompt" .agents/skills/ 2>/dev/null; then
  fail "Stale reference to reviewer-prompt.md found in skills"
else
  pass "No stale references to reviewer-prompt.md"
fi

# No TypeScript file extensions in Go-focused skills (e.g., foo.ts, bar.tsx)
ts_hits=$(grep -rnE '\w+\.tsx?\b' .agents/skills/ 2>/dev/null | grep -v 'node_modules' | grep -v '\.md:.*codex-plugin' | grep -v 'config\.toml' || true)
if [ -n "$ts_hits" ]; then
  fail "Possible TypeScript file references in skills: $ts_hits"
else
  pass "No TypeScript file references in skills"
fi

# ---------------------------------------------------------------------------
section "8. README consistency"
# ---------------------------------------------------------------------------

# All skills in the skills table
for skill in $EXPECTED_SKILLS; do
  if grep -qF "**${skill}**" README.md; then
    pass "README lists $skill"
  else
    fail "README missing $skill in skills table"
  fi
done

# Plugin reference
if grep -q "codex-plugin-cc" README.md; then
  pass "README references codex plugin"
else
  fail "README missing codex plugin reference"
fi

# Upstream sources include codex-plugin-cc
if grep -q "openai/codex-plugin-cc" README.md; then
  pass "README lists codex-plugin-cc as upstream"
else
  fail "README missing codex-plugin-cc in upstream sources"
fi

# ---------------------------------------------------------------------------
section "9. Principles"
# ---------------------------------------------------------------------------

EXPECTED_PRINCIPLES="foundational-thinking redesign-from-first-principles subtract-before-you-add experience-first exhaust-the-design-space module-depth boundary-discipline make-operations-idempotent serialize-shared-state-mutations prove-it-works fix-root-causes stop-on-ambiguity encode-lessons-in-structure"

for p in $EXPECTED_PRINCIPLES; do
  f="docs/principles/$p.md"
  [ -f "$f" ] && pass "$p" || fail "$p missing"
done

# Index references all principles
for p in $EXPECTED_PRINCIPLES; do
  if grep -q "$p" docs/principles/index.md; then
    pass "index.md references $p"
  else
    fail "index.md missing reference to $p"
  fi
done

# ---------------------------------------------------------------------------
section "10. Adversarial-review skill content"
# ---------------------------------------------------------------------------

skill=".agents/skills/adversarial-review/SKILL.md"

# References codex plugin
if grep -q "codex:adversarial-review" "$skill"; then
  pass "Skill mentions /codex:adversarial-review as alternative"
else
  fail "Skill should reference /codex:adversarial-review"
fi

# Uses codex exec for spawning
if grep -q "codex exec" "$skill"; then
  pass "Skill uses codex exec for reviewers"
else
  fail "Skill should use codex exec"
fi

# Has preflight check
if grep -q "command -v codex" "$skill"; then
  pass "Skill has preflight check for codex CLI"
else
  fail "Skill missing preflight check"
fi

# Has wait/synchronization step
if grep -qi "wait for all reviewers" "$skill"; then
  pass "Skill has explicit wait step before synthesis"
else
  fail "Skill missing wait step before synthesis"
fi

# Stderr captured to .err files (not suppressed)
if grep -q '\.err' "$skill"; then
  pass "Skill captures stderr to .err files"
else
  fail "Skill should capture stderr to .err files, not suppress"
fi

# References lenses
if grep -q "reviewer-lenses.md" "$skill"; then
  pass "Skill references reviewer-lenses.md"
else
  fail "Skill should reference reviewer-lenses.md"
fi

# References verdict format
if grep -q "verdict-format.md" "$skill"; then
  pass "Skill references verdict-format.md"
else
  fail "Skill should reference verdict-format.md"
fi

# Prompt construction inlined (no reference to reviewer-prompt.md)
if ! grep -q "reviewer-prompt" "$skill"; then
  pass "No reference to removed reviewer-prompt.md"
else
  fail "Still references reviewer-prompt.md"
fi

# ---------------------------------------------------------------------------
# Summary
# ---------------------------------------------------------------------------

printf "\n\033[1m━━━ Results: %d passed, %d failed ━━━\033[0m\n" "$PASS" "$FAIL"

if [ "$FAIL" -gt 0 ]; then
  exit 1
else
  printf "\033[32mAll checks passed.\033[0m\n"
fi
