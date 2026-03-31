---
name: adversarial-review
description: >-
  Deep multi-lens adversarial code review. Spawns multiple Codex reviewers with distinct
  critical lenses (Architect, Skeptic, Minimalist) grounded in project principles. Produces
  a synthesized verdict with lead judgment. For quick single-lens adversarial reviews, use
  /codex:adversarial-review from the codex plugin instead. Use this skill for large changes
  (200+ lines), high-stakes code like smart contracts, or when you want multi-perspective analysis.
---

# Adversarial Review

Deep multi-lens adversarial review. Spawns **multiple** Codex reviewers with distinct critical
lenses grounded in project principles. The deliverable is a synthesized verdict — do NOT make
changes.

**Prerequisite:** Requires the Codex CLI installed and authenticated (`codex login`). The
[codex plugin](https://github.com/openai/codex-plugin-cc) is recommended but not required —
this skill uses `codex exec` directly.

> **Quick alternative:** For a single adversarial review without multi-lens orchestration,
> use `/codex:adversarial-review` directly (requires the codex plugin).

## Step 1 — Load Principles

Read `docs/principles/index.md` and follow links to relevant principle files. These govern
reviewer judgments.

## Step 2 — Determine Scope and Intent

Identify what to review from context (recent diffs, referenced plans, user message).

Determine the **intent** — what the author is trying to achieve. This is critical: reviewers
challenge whether the work *achieves the intent well*, not whether the intent is correct.
State the intent explicitly before proceeding.

Assess change size:

| Size | Threshold | Reviewers |
|------|-----------|-----------|
| Small | < 50 lines, 1-2 files | 1 (Skeptic) |
| Medium | 50-200 lines, 3-5 files | 2 (Skeptic + Architect) |
| Large | 200+ lines or 5+ files | 3 (Skeptic + Architect + Minimalist) |

Read `references/reviewer-lenses.md` for lens definitions.

## Step 3 — Preflight Check

Before spawning reviewers, verify Codex is available:

```sh
command -v codex >/dev/null 2>&1 || { echo "ERROR: codex CLI not found. Install with: npm install -g @openai/codex"; exit 1; }
```

If Codex is not installed or not authenticated, stop and tell the user what to run.

## Step 4 — Spawn Reviewers via Codex

Create a temp directory for reviewer output and logs:

```sh
REVIEW_DIR=$(mktemp -d /tmp/adversarial-review.XXXXXX)
```

For each required lens, spawn a Codex reviewer using `codex exec` in read-only sandbox:

```sh
codex exec -s read-only -o "$REVIEW_DIR/skeptic.md" "prompt" 2>"$REVIEW_DIR/skeptic.err"
```

Run each reviewer with `run_in_background: true`. Name output files after the lens:
`skeptic.md`, `architect.md`, `minimalist.md`. Redirect stderr to per-lens `.err` files
for diagnostics.

**Prompt construction** — each reviewer gets:

1. The stated intent (from Step 2)
2. Their assigned lens (full text from `references/reviewer-lenses.md`)
3. The principles relevant to their lens (file contents from `docs/principles/`, not summaries)
4. The code or diff to review
5. Closing instruction: "You are an adversarial reviewer. Your job is to find real problems,
   not validate the work. Be specific — cite files, lines, and concrete failure scenarios.
   Rate each finding: high (blocks ship), medium (should fix), low (worth noting).
   Write findings as a numbered markdown list."

Spawn all reviewers in parallel.

## Step 5 — Wait for All Reviewers

**Do NOT proceed until every reviewer has finished.** Poll each background task until
completion. For each reviewer, confirm:

1. The background task exited (check via the task management mechanism you used to launch it)
2. The output file exists and is non-empty

If a reviewer fails, read its `.err` file for diagnostics and report the specific error
(auth expired, binary missing, timeout, etc.) — do not silently skip it.

## Step 6 — Synthesize Verdict

Read each reviewer's output file from `$REVIEW_DIR/`. Deduplicate overlapping findings.
Produce a single verdict using the format in `references/verdict-format.md`.

## Step 7 — Render Lead Judgment

After synthesizing the reviewers, apply your own judgment. Using the stated intent and project
principles as your frame, state which findings you would accept and which you would reject —
and why. Reviewers are adversarial by design; not every finding warrants action. Call out
false positives, overreach, and findings that mistake style for substance.

Append the Lead Judgment section to the verdict (see `references/verdict-format.md`).
