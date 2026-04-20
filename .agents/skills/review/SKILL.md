---
name: review
description: |
  Pre-landing PR review. Analyzes diff against base branch for structural issues,
  scope drift, test coverage gaps, and code quality. Use when asked to "review this PR",
  "code review", "check my diff", or before merging code.
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

## Step 1: Check branch

1. Run `git branch --show-current` to get the current branch.
2. If on the base branch, output: **"Nothing to review -- you're on the base branch or have no changes against it."** and stop.
3. Run `git fetch origin <base> --quiet && git diff origin/<base> --stat` to check if there's a diff. If no diff, output the same message and stop.

---

## Step 2: Scope Drift Detection

Before reviewing code quality, check: **did they build what was requested -- nothing more, nothing less?**

1. Read PR description (`gh pr view --json body --jq .body 2>/dev/null || true`).
   Read commit messages (`git log origin/<base>..HEAD --oneline`).
   **If no PR exists:** rely on commit messages for stated intent -- this is common since /review runs before creating a PR.
2. Identify the **stated intent** -- what was this branch supposed to accomplish?
3. Run `git diff origin/<base>...HEAD --stat` and compare the files changed against the stated intent.
4. Evaluate with skepticism:

   **SCOPE CREEP detection:**
   - Files changed that are unrelated to the stated intent
   - New features or refactors not mentioned in commit messages or PR description
   - "While I was in there..." changes that expand blast radius

   **MISSING REQUIREMENTS detection:**
   - Requirements from the PR description not addressed in the diff
   - Test coverage gaps for stated requirements
   - Partial implementations (started but not finished)

5. Output (before the main review begins):
   ```
   Scope Check: [CLEAN / DRIFT DETECTED / REQUIREMENTS MISSING]
   Intent: <1-line summary of what was requested>
   Delivered: <1-line summary of what the diff actually does>
   [If drift: list each out-of-scope change]
   [If missing: list each unaddressed requirement]
   ```

6. **Investigation depth** — for each PARTIAL or NOT DONE requirement, investigate *why*:
   - Check `git log origin/<base>..HEAD --oneline` for commits suggesting the work was started, attempted, or reverted
   - Read the relevant code to understand what was built instead
   - Classify the reason:
     - **Scope cut** — evidence of intentional removal (revert commit, removed TODO)
     - **Context exhaustion** — work started but stopped mid-way (partial implementation, no follow-up commits)
     - **Misunderstood requirement** — something was built but doesn't match what was described
     - **Blocked by dependency** — item depends on something not yet available
     - **Genuinely forgotten** — no evidence of any attempt

   Output for each:
   ```
   DISCREPANCY: {PARTIAL|NOT_DONE} | {requirement} | {what was actually delivered}
   INVESTIGATION: {reason with evidence from git log / code}
   IMPACT: {HIGH|MEDIUM|LOW} — {what breaks or degrades if undelivered}
   ```

7. **HIGH-impact gating** — if any discrepancy is HIGH impact, use AskUserQuestion:
   - Show the investigation findings
   - Options: A) Stop and implement missing items, B) Ship anyway + create P1 TODOs, C) Intentionally dropped — remove from scope

   This is **INFORMATIONAL** unless HIGH-impact discrepancies are found (then it gates via AskUserQuestion). Proceed to Step 3.

---

## Step 3: Get the diff

Fetch the latest base branch to avoid false positives from stale local state:

```bash
git fetch origin <base> --quiet
```

Run `git diff origin/<base>` to get the full diff. This includes both committed and uncommitted changes against the latest base branch.

---

## Step 4: Two-pass review

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

## Step 4.5: Specialist Lenses

After the two-pass review, re-examine the diff through domain-specific lenses based on what the diff touches. Only apply lenses that match — skip the rest.

**Detect signals** from the diff (`git diff origin/<base> --stat` and file content):

| Signal | Lens |
|--------|------|
| Auth, permissions, access control, tokens, sessions | **Security** |
| DB migrations, schema changes, ALTER TABLE | **Data Safety** |
| API routes, handlers, request/response contracts | **API Contract** |
| DB queries, loops over collections, data fetching | **Performance** |

### Security Lens

When the diff touches auth/permissions/access control code:
- Input validation at trust boundaries — are all external inputs validated before use?
- Auth/authz bypass — can the new code path be reached without proper authentication?
- Injection vectors beyond SQL — command injection, path traversal, SSRF
- Cryptographic misuse — hardcoded secrets, weak algorithms, improper key management
- Attack surface expansion — does this change expose new endpoints or capabilities?

### Data Safety Lens

When the diff touches migrations or schema:
- Reversibility — can this migration be rolled back without data loss?
- Data loss risk — dropping columns, narrowing types, adding NOT NULL without defaults
- Lock duration — will ALTER TABLE lock production tables for an unacceptable duration?
- Migration ordering — does this migration depend on another that may not have run?

### API Contract Lens

When the diff touches API routes or contracts:
- Breaking changes — removed fields, type changes, new required parameters
- Versioning consistency — does this follow the project's API versioning strategy?
- Error response standardization — do new error cases follow existing patterns?
- Backward compatibility — will existing clients break?

### Performance Lens

When the diff touches queries or data-fetching code:
- N+1 queries — loops that issue a query per iteration
- Missing indexes — new queries on columns without indexes
- Algorithmic complexity — O(n²) patterns, unbounded iterations
- Large payloads — endpoints returning unbounded result sets without pagination

Specialist lens findings follow the same confidence calibration and finding format as Step 4. They flow into Step 6 (Fix-First) alongside the two-pass findings.

---

## Step 5: Test Coverage Analysis

Evaluate every codepath changed in the diff and identify test gaps. Gaps become INFORMATIONAL findings that follow the Fix-First flow.

### Detect test framework

1. Read CLAUDE.md -- look for a `## Testing` section with test command and framework name.
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
3. If no framework detected: still produce the coverage diagram, but skip test generation.

### Trace codepaths

Read every changed file (full file, not just diff hunk). For each one, trace data flow: where input comes from, what transforms it, where it goes, and what can go wrong. Diagram every conditional branch, error path, and function call.

### Map against existing tests

For each branch, search for a test that exercises it. Quality: three stars = edge cases + error paths, two stars = happy path only, one star = smoke test / trivial assertion.

### Output ASCII coverage diagram

```
CODE PATH COVERAGE
===========================
[+] internal/billing/service.go
    |
    +-- ProcessPayment()
    |   +-- [*** TESTED] Happy path + card declined + timeout -- billing_test.go:42
    |   +-- [GAP]        Network timeout -- NO TEST
    |   +-- [GAP]        Invalid currency -- NO TEST
    |
    +-- RefundPayment()
        +-- [**  TESTED] Full refund -- billing_test.go:89
        +-- [*   TESTED] Partial refund (trivial assertion) -- billing_test.go:101

------------------------------
COVERAGE: 3/5 paths tested (60%)
QUALITY:  ***: 1  **: 1  *: 1
GAPS: 2 paths need tests
------------------------------
```

### Generate tests for gaps (Fix-First)

If test framework is detected and gaps were identified:
- **AUTO-FIX:** Simple unit tests for pure functions, edge cases of existing tested functions. Generate, run, commit as `test: coverage for {feature}`.
- **ASK:** E2E tests, tests requiring new infrastructure, tests for ambiguous behavior. Include in the Fix-First batch question.

If no test framework detected: include gaps as INFORMATIONAL findings only, no generation.

**Diff is test-only changes:** Skip this step: "No new application code paths to audit."

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
- For each item, provide options: A) Fix as recommended, B) Skip
- Include an overall RECOMMENDATION

Example:
```
I auto-fixed 5 issues. 2 need your input:

1. [CRITICAL] internal/store/post.go:42 -- Race condition in status transition
   Fix: Add `WHERE status = 'draft'` to the UPDATE
   -> A) Fix  B) Skip

2. [INFORMATIONAL] internal/service/generator.go:88 -- LLM output not type-checked before DB write
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

---

## Step 6e: PR Quality Score

After all fixes are applied (or skipped), compute and display:

```
PR Quality Score: max(0, 10 - (critical_count * 2 + informational_count * 0.5))
```

Where `critical_count` and `informational_count` are the **remaining** findings after fixes. Cap at 10. Display alongside the summary.

---

## Step 7: Adversarial Review Nudge

After the review is complete, always suggest running `/adversarial-review` regardless of diff size. LOC is not a proxy for risk — a 5-line auth change can be critical.

```
💡 Consider running /adversarial-review for cross-model analysis of this diff.
```

---

## Important Rules

- **Read the FULL diff before commenting.** Do not flag issues already addressed in the diff.
- **Fix-first, not read-only.** AUTO-FIX items are applied directly. ASK items are only applied after user approval. Never commit, push, or create PRs.
- **Be terse.** One line problem, one line fix. No preamble.
- **Only flag real problems.** Skip anything that's fine.
