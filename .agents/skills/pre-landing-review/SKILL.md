---
name: pre-landing-review
description: |
  Pre-landing review of the working branch's diff against the base branch: structural issues,
  scope drift, test coverage gaps, and code quality. Use when asked to "review my changes",
  "check my diff", "code review", or before merging or opening a PR.
---

# Pre-Landing PR Review

Analyze the current branch's diff against the base branch for structural issues that tests don't catch.

---

## Step 0: Detect base branch

Detect platform from `git remote get-url origin 2>/dev/null` (github.com -> GitHub, gitlab -> GitLab, otherwise unknown).

**GitHub:** Try `gh pr view --json baseRefName -q .baseRefName`, then `gh repo view --json defaultBranchRef -q .defaultBranchRef.name`.

**GitLab:** Try `glab mr view -F json` and extract `target_branch`, then `glab repo view -F json` and extract `default_branch`.

**Git-native fallback:** Try `git symbolic-ref refs/remotes/origin/HEAD | sed 's|refs/remotes/origin/||'`, then `git rev-parse --verify origin/main`, then `origin/master`. If all fail, use `main`.

Use the detected branch wherever instructions say `<base>`.

---

## Step 1: Get the diff

1. Run `git branch --show-current`. If on the base branch, output **"Nothing to review -- you're on the base branch or have no changes against it."** and stop.
2. Fetch and diff from the merge base — this includes uncommitted changes while excluding commits that landed on base after this branch was created:

   ```bash
   git fetch origin <base> --quiet
   DIFF_BASE=$(git merge-base origin/<base> HEAD)
   git diff "$DIFF_BASE"
   ```

3. If the diff is empty, output the same message and stop. Reuse `$DIFF_BASE` in every later step.

---

## Step 2: Scope Drift Detection

Before reviewing code quality, check: **did they build what was requested -- nothing more, nothing less?** This step enforces `docs/principles/surgical-changes.md` at PR level.

1. Identify the **stated intent** from the PR description (`gh pr view --json body --jq .body 2>/dev/null || true`) and commit messages (`git log origin/<base>..HEAD --oneline`). If no PR exists, commit messages carry the intent — common, since this skill runs before creating a PR.
2. Compare `git diff "$DIFF_BASE" --stat` against the intent, with skepticism in both directions:
   - **Scope creep** — files unrelated to the stated intent, features or refactors nothing mentions, "while I was in there" changes that expand blast radius.
   - **Missing requirements** — stated requirements the diff doesn't address, partial implementations, test gaps for stated behavior.
3. For each partial or missing requirement, investigate **why** before reporting: check `git log origin/<base>..HEAD` for started, reverted, or abandoned work, and read the code to see what was built instead. Was it intentionally cut, abandoned mid-way, misunderstood, blocked by a dependency, or forgotten? State the reason **with evidence**, plus the impact (HIGH/MEDIUM/LOW — what breaks or degrades if undelivered).
4. Output before the main review begins:

   ```
   Scope Check: [CLEAN / DRIFT DETECTED / REQUIREMENTS MISSING]
   Intent: <1-line summary of what was requested>
   Delivered: <1-line summary of what the diff actually does>
   [each out-of-scope change; each missing requirement with reason, evidence, impact]
   ```

5. **HIGH-impact gating** — if any missing requirement is HIGH impact, use AskUserQuestion with the findings and options: A) stop and implement the missing items, B) ship anyway and create P1 TODOs, C) intentionally dropped — remove from scope. Otherwise this step is informational; proceed.

---

## Step 3: Two-pass review

Apply the review against the diff in two passes:

### Pass 1 (CRITICAL)

1. **SQL & Data Safety** -- injection, mass assignment, unvalidated input in queries, missing transactions around multi-step writes.
2. **Race Conditions & Concurrency** -- TOCTOU, shared mutable state without locks, non-atomic read-modify-write, missing optimistic locking.
3. **Trust Boundary Violations** -- LLM output used without validation, user input trusted without sanitization, external API responses used without type checking.
4. **Enum & Value Completeness** -- when the diff introduces a new enum value, status, tier, or type constant, use Grep to find ALL files that reference sibling values, then Read those files to check if the new value is handled. This is the one category where within-diff review is insufficient.

### Pass 2 (INFORMATIONAL)

1. **Conditional Side Effects** -- state mutations buried inside complex conditions, side effects in getters, mutation in filter/map callbacks.
2. **Magic Numbers & String Coupling** -- hardcoded values that should be constants, string matching on values that could change.
3. **Dead Code & Consistency** -- unreachable branches, inconsistent patterns across similar code.
4. **Test Gaps** -- new code paths without tests (subsumes into the coverage analysis in Step 5).
5. **Performance** -- N+1 queries, unbounded loops, missing pagination, large payloads.
6. **AI Code Quality (advisory)** -- patterns common in AI-generated code: empty catch blocks that swallow errors, over-abstracted wrappers around single-use logic, defensive validation for impossible internal states, copy-paste patterns that should be a shared function.

**Search-before-recommending:** When recommending a fix, verify it's current best practice for the framework version in use. Check if a built-in solution exists before recommending a workaround.

### Confidence Calibration

Every finding MUST include a confidence score (1-10):

| Score | Meaning | Display rule |
|-------|---------|-------------|
| 9-10 | Verified by reading specific code. Concrete bug demonstrated. | Show normally |
| 7-8 | High confidence pattern match. Very likely correct. | Show normally |
| 5-6 | Moderate. Could be a false positive. | Show with caveat |
| 3-4 | Low confidence. | Suppress from main report. Appendix only. |
| 1-2 | Speculation. | Only report if severity would be P0. |

**Finding format:**

`[SEVERITY] (confidence: N/10) file:line -- description`

Examples:
`[P1] (confidence: 9/10) internal/store/user.go:42 -- SQL injection via string interpolation in query`
`[P2] (confidence: 5/10) internal/api/handler/users.go:18 -- Possible N+1 query, verify with production logs`

---

## Step 4: Specialist Lenses

After the two-pass review, re-examine the diff through domain-specific lenses. Detect signals from the diff stat and content; apply only the lenses that match, skip the rest:

| Signal | Lens |
|--------|------|
| Auth, permissions, access control, tokens, sessions | **Security** |
| DB migrations, schema changes, ALTER TABLE | **Data Safety** |
| API routes, handlers, request/response contracts | **API Contract** |
| DB queries, loops over collections, data fetching | **Performance** |

Read [references/specialist-lenses.md](references/specialist-lenses.md) for the matched lenses' checklists. Lens findings use the same confidence calibration and finding format as Step 3 and flow into Step 6 (Fix-First).

---

## Step 5: Test Coverage Analysis

Evaluate every codepath changed in the diff and identify test gaps. Gaps become INFORMATIONAL findings that follow the Fix-First flow.

**Diff is test-only changes:** skip this step: "No new application code paths to audit."

### Detect test framework

1. Read AGENTS.md -- look for a `## Commands` section with test command and framework name.
2. If not found, auto-detect:
   ```bash
   [ -f Gemfile ] && echo "RUNTIME:ruby"
   [ -f package.json ] && echo "RUNTIME:node"
   [ -f requirements.txt ] || [ -f pyproject.toml ] && echo "RUNTIME:python"
   [ -f go.mod ] && echo "RUNTIME:go"
   [ -f Cargo.toml ] && echo "RUNTIME:rust"
   ls jest.config.* vitest.config.* playwright.config.* cypress.config.* .rspec pytest.ini phpunit.xml 2>/dev/null
   ls -d test/ tests/ spec/ __tests__/ cypress/ e2e/ 2>/dev/null
   ```
3. If no framework detected: still produce the coverage report, but skip test generation.

### Trace codepaths and map tests

Read every changed file in full (not just the diff hunk). For each, trace data flow -- where input comes from, what transforms it, where it goes, what can go wrong -- covering every conditional branch, error path, and function call. For each path, find the test that exercises it and rate quality: `***` edge cases + error paths, `**` happy path only, `*` smoke test / trivial assertion.

### Output

One line per codepath, then a summary:

```
[***] ProcessPayment: happy path + card declined + timeout -- billing_test.go:42
[GAP] ProcessPayment: network timeout -- NO TEST
[GAP] ProcessPayment: invalid currency -- NO TEST
[** ] RefundPayment: full refund -- billing_test.go:89
COVERAGE: 2/4 paths tested. GAPS: 2 paths need tests.
```

### Generate tests for gaps (Fix-First)

If a test framework is detected and gaps were identified:
- **AUTO-FIX:** Simple unit tests for pure functions, edge cases of existing tested functions. Generate and run them, then leave the new tests unstaged for the user to commit (this skill never commits — see Important Rules).
- **ASK:** E2E tests, tests requiring new infrastructure, tests for ambiguous behavior. Include in the Fix-First batch question.

If no test framework detected: include gaps as INFORMATIONAL findings only, no generation.

**REGRESSION RULE (mandatory):** When the audit identifies a regression -- code that previously worked but the diff broke -- a regression test is written immediately. No asking. Regressions are the highest-priority test.

---

## Step 6: Fix-First Review

**Every finding gets action -- not just critical ones.**

Output a summary header: `Pre-Landing Review: N issues (X critical, Y informational)`

### Step 6a: Classify each finding

- **AUTO-FIX:** Obvious, mechanical fixes (missing null checks, unused imports, typos, simple type errors). Apply directly without asking.
- **ASK:** Fixes needing judgment (architectural changes, behavior changes, security-sensitive changes, anything where two reasonable developers might disagree).

Critical findings lean toward ASK. Informational toward AUTO-FIX.

### Step 6b: Auto-fix all AUTO-FIX items

Apply each fix directly. For each one, output a one-line summary:
`[AUTO-FIXED] [file:line] Problem -> what you did`

### Step 6c: Batch-ask about ASK items

If there are ASK items remaining, present them in one batch:

- List each item with a number, severity label, problem, and recommended fix
- **State the stakes:** For each item, say what breaks or degrades if left unfixed — the user needs this to prioritize
- For each item, provide options: A) Fix as recommended, B) Skip
- Include an overall RECOMMENDATION

Example:
```
I auto-fixed 5 issues. 2 need your input:

1. [CRITICAL] internal/store/post.go:42 -- Race condition in status transition
   Stakes: concurrent publishes can overwrite each other, losing edits silently
   Fix: Add `WHERE status = 'draft'` to the UPDATE
   -> A) Fix  B) Skip

2. [INFORMATIONAL] internal/service/generator.go:88 -- LLM output not type-checked before DB write
   Stakes: malformed JSON from the model silently corrupts stored records
   Fix: Add JSON schema validation
   -> A) Fix  B) Skip

RECOMMENDATION: Fix both -- #1 is a real race condition, #2 prevents silent data corruption.
```

### Step 6d: Apply user-approved fixes

Apply fixes for items where the user chose "Fix." Output what was fixed.

If no ASK items exist (everything was AUTO-FIX), skip the question entirely.

### Verification of claims

Before producing the final review output:
- If you claim "this pattern is safe" -> cite the specific line proving safety
- If you claim "this is handled elsewhere" -> read and cite the handling code
- If you claim "tests cover this" -> name the test file and method
- Never say "likely handled" or "probably tested" -- verify or flag as unknown

**Rationalization prevention:** "This looks fine" is not a finding. Either cite evidence it IS fine, or flag it as unverified.

**Evidence ladder for safety-critical claims.** Citing a line is not the top of the ladder. For each claim the change's safety actually depends on, push it as far down this ladder as is cheap, and state where it stopped:

1. *Asserted* -- "it's safe because I say so." Worthless on its own.
2. *Cited* -- a real `file:line`, or the dependency's own source, that shows it.
3. *Traced* -- you walked the failure case step by step and it cannot reach.
4. *Executed* -- a script or test that calls the real code and fails loud if you're wrong.
5. *Reproduced* -- observed in the running system.

A safety claim you cannot get to step 4 cheaply, label **unproven** -- do not round a level-2 cite up to "verified." Step 4 is usually one small script that exercises the exact code path in question.

**Concentrate the proof.** A change that looks risky is usually safe because of a single fact ("this only drops already-dead entries"). Find that one fact and prove *it*, rather than writing a long list of maybes -- if it holds, most of the scary cases fall at once.

---

## Step 7: Adversarial Review Nudge

After the review is complete, suggest running `/adversarial-review` when the diff is large (200+ lines) or touches high-stakes code — auth, money movement, smart contracts, or other security boundaries. LOC is not the only risk signal: a 5-line auth change can warrant it, so judge by blast radius, not line count alone.

```
💡 Consider running /adversarial-review for cross-model analysis of this diff.
```

---

## Important Rules

- **Read the FULL diff before commenting.** Do not flag issues already addressed in the diff.
- **Fix-first, not read-only.** AUTO-FIX items are applied directly. ASK items are only applied after user approval. Never commit, push, or create PRs.
- **Be terse.** One line problem, one line fix. No preamble.
- **Only flag real problems.** Skip anything that's fine.
- **AskUserQuestion fallback.** Step 2 HIGH-impact gating and Step 6c batch-asks assume the structured AskUserQuestion tool. If it is unavailable or a call errors, do not stall: in an interactive session, render the question as a prose brief — number each decision, give a one-line stakes statement, list lettered options with a `Recommendation: <letter> because <reason>` line, and let the user reply with a letter. In a headless or non-interactive run, do not block — record the open decisions in the review output, proceed with the recommended (reversible) option per `docs/principles/never-block-on-the-human.md`, and leave the irreversible ones flagged for the human.
