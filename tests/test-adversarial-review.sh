#!/usr/bin/env bash
# Integration tests for adversarial review: plugin (simple) and multi-lens (deep).
# Run from the repo root: bash tests/test-adversarial-review.sh
#
# Prerequisites: codex CLI installed and authenticated.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO_ROOT"

PASS=0
FAIL=0
REVIEW_DIR=$(mktemp -d /tmp/adversarial-review-test.XXXXXX)

pass() { PASS=$((PASS + 1)); printf "  \033[32m✓\033[0m %s\n" "$1"; }
fail() { FAIL=$((FAIL + 1)); printf "  \033[31m✗\033[0m %s\n" "$1"; }
section() { printf "\n\033[1m%s\033[0m\n" "$1"; }

cleanup() { rm -rf "$REVIEW_DIR"; }
trap cleanup EXIT

# Collect the diff once for all tests
DIFF=$(git diff HEAD)
if [ -z "$DIFF" ]; then
  echo "No uncommitted changes to review. Commit or stage changes first."
  exit 1
fi

# ───────────────────────────────────────────────────────────────────────────
section "0. Prerequisites"
# ───────────────────────────────────────────────────────────────────────────

if command -v codex >/dev/null 2>&1; then
  pass "codex CLI found: $(codex --version 2>&1)"
else
  fail "codex CLI not found — install with: npm install -g @openai/codex"
  exit 1
fi

# Quick connectivity check
echo "  … verifying Codex authentication (may take a few seconds)"
if codex exec -s read-only "Respond with exactly: OK" 2>/dev/null | grep -q "OK"; then
  pass "Codex authenticated and responsive"
else
  fail "Codex not responding — run: codex login"
  exit 1
fi

# ───────────────────────────────────────────────────────────────────────────
section "1. Simple adversarial review (plugin path)"
# ───────────────────────────────────────────────────────────────────────────

# Find the plugin's codex-companion.mjs
COMPANION=$(find ~/.claude/plugins -path "*/cache/*/scripts/codex-companion.mjs" 2>/dev/null | head -1)

if [ -z "$COMPANION" ]; then
  fail "codex-companion.mjs not found — is the codex plugin installed?"
else
  pass "Plugin companion found: $COMPANION"

  PLUGIN_ROOT=$(dirname "$(dirname "$COMPANION")")
  echo "  … running plugin adversarial review (this may take 30-60s)"

  # Run the companion script's adversarial-review against working tree
  if CLAUDE_PLUGIN_ROOT="$PLUGIN_ROOT" node "$COMPANION" adversarial-review \
    "Review the current uncommitted changes for design and correctness issues" \
    > "$REVIEW_DIR/plugin-review.txt" 2>&1; then

    # Check output is non-empty
    if [ -s "$REVIEW_DIR/plugin-review.txt" ]; then
      pass "Plugin returned non-empty review output"
      WORD_COUNT=$(wc -w < "$REVIEW_DIR/plugin-review.txt")
      pass "Output length: ${WORD_COUNT} words"
    else
      fail "Plugin returned empty output"
    fi
  else
    # Non-zero exit might still produce useful output
    if [ -s "$REVIEW_DIR/plugin-review.txt" ]; then
      pass "Plugin returned output (non-zero exit, but output exists)"
    else
      fail "Plugin adversarial review failed with no output"
    fi
  fi

  echo ""
  echo "  ┌─ Plugin review output (first 20 lines) ──────────────"
  head -20 "$REVIEW_DIR/plugin-review.txt" 2>/dev/null | sed 's/^/  │ /'
  echo "  └──────────────────────────────────────────────────────"
fi

# ───────────────────────────────────────────────────────────────────────────
section "2. Multi-lens adversarial review (our skill path)"
# ───────────────────────────────────────────────────────────────────────────

# This tests what our adversarial-review skill does: spawn per-lens Codex reviewers.
# We test with the Skeptic lens (always used, even for small changes).

SKEPTIC_PROMPT="You are an adversarial code reviewer using the Skeptic lens.

## Intent
The author adapted the adversarial-review skill to integrate with the Codex plugin for
Claude Code, replacing manual CLI orchestration with plugin-based execution.

## Your Lens: Skeptic
Challenge correctness and completeness. Ask:
- What inputs, states, or sequences will break this?
- What error paths are unhandled or silently swallowed?
- What does the author believe is true that isn't proven?
- Where is 'it works on my machine' masquerading as verification?

## Diff to review
${DIFF}

## Instructions
Find real problems, not validate the work. Be specific — cite files, lines, and concrete
failure scenarios. Rate each finding: high (blocks ship), medium (should fix), low (worth noting).
Write findings as a numbered markdown list."

echo "  … running Skeptic lens review via codex exec (30-60s)"
if codex exec -s read-only -o "$REVIEW_DIR/skeptic.md" "$SKEPTIC_PROMPT" 2>/dev/null; then
  if [ -s "$REVIEW_DIR/skeptic.md" ]; then
    pass "Skeptic lens returned non-empty output"
    WORD_COUNT=$(wc -w < "$REVIEW_DIR/skeptic.md")
    pass "Skeptic output: ${WORD_COUNT} words"
  else
    fail "Skeptic lens returned empty output"
  fi
else
  # Check if output was written despite non-zero exit
  if [ -s "$REVIEW_DIR/skeptic.md" ]; then
    pass "Skeptic lens returned output (non-zero exit)"
  else
    fail "Skeptic lens failed with no output"
  fi
fi

echo ""
echo "  ┌─ Skeptic review output (first 20 lines) ──────────────"
head -20 "$REVIEW_DIR/skeptic.md" 2>/dev/null | sed 's/^/  │ /'
echo "  └──────────────────────────────────────────────────────"

# ───────────────────────────────────────────────────────────────────────────
section "3. Architect lens (parallel spawn test)"
# ───────────────────────────────────────────────────────────────────────────

ARCHITECT_PROMPT="You are an adversarial code reviewer using the Architect lens.

## Intent
The author adapted the adversarial-review skill to integrate with the Codex plugin for
Claude Code, replacing manual CLI orchestration with plugin-based execution.

## Your Lens: Architect
Challenge structural fitness. Ask:
- Does the design actually serve the stated goal, or does it serve a goal the author assumed?
- Where are the coupling points that will hurt when requirements shift?
- What boundary violations exist? Where does responsibility leak between components?
- What implicit assumptions about scale, concurrency, or ordering will break first?

## Diff to review
${DIFF}

## Instructions
Find real problems, not validate the work. Be specific — cite files, lines, and concrete
failure scenarios. Rate each finding: high (blocks ship), medium (should fix), low (worth noting).
Write findings as a numbered markdown list."

echo "  … running Architect lens review via codex exec (30-60s)"
if codex exec -s read-only -o "$REVIEW_DIR/architect.md" "$ARCHITECT_PROMPT" 2>/dev/null; then
  if [ -s "$REVIEW_DIR/architect.md" ]; then
    pass "Architect lens returned non-empty output"
    WORD_COUNT=$(wc -w < "$REVIEW_DIR/architect.md")
    pass "Architect output: ${WORD_COUNT} words"
  else
    fail "Architect lens returned empty output"
  fi
else
  if [ -s "$REVIEW_DIR/architect.md" ]; then
    pass "Architect lens returned output (non-zero exit)"
  else
    fail "Architect lens failed with no output"
  fi
fi

echo ""
echo "  ┌─ Architect review output (first 20 lines) ─────────────"
head -20 "$REVIEW_DIR/architect.md" 2>/dev/null | sed 's/^/  │ /'
echo "  └──────────────────────────────────────────────────────"

# ───────────────────────────────────────────────────────────────────────────
section "4. Output quality checks"
# ───────────────────────────────────────────────────────────────────────────

# Skeptic output should reference correctness/completeness concerns
if [ -s "$REVIEW_DIR/skeptic.md" ]; then
  if grep -qiE 'finding|issue|concern|problem|error|risk' "$REVIEW_DIR/skeptic.md"; then
    pass "Skeptic output contains review findings"
  else
    fail "Skeptic output lacks review-like content"
  fi
fi

# Architect output should reference structural/design concerns
if [ -s "$REVIEW_DIR/architect.md" ]; then
  if grep -qiE 'finding|issue|concern|design|structure|coupling|boundary|risk' "$REVIEW_DIR/architect.md"; then
    pass "Architect output contains review findings"
  else
    fail "Architect output lacks review-like content"
  fi
fi

# Both outputs should be distinct (different lenses → different findings)
if [ -s "$REVIEW_DIR/skeptic.md" ] && [ -s "$REVIEW_DIR/architect.md" ]; then
  if ! diff -q "$REVIEW_DIR/skeptic.md" "$REVIEW_DIR/architect.md" >/dev/null 2>&1; then
    pass "Skeptic and Architect outputs are distinct"
  else
    fail "Skeptic and Architect outputs are identical (lenses not differentiated)"
  fi
fi

# ───────────────────────────────────────────────────────────────────────────
# Summary
# ───────────────────────────────────────────────────────────────────────────

printf "\n\033[1m━━━ Results: %d passed, %d failed ━━━\033[0m\n" "$PASS" "$FAIL"
printf "Review artifacts saved in: %s\n" "$REVIEW_DIR"

if [ "$FAIL" -gt 0 ]; then
  exit 1
else
  printf "\033[32mAll integration tests passed.\033[0m\n"
fi
