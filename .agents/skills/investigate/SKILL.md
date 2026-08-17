---
name: investigate
description: Systematic debugging with root cause investigation. Use when encountering any bug, test failure, or unexpected behavior, before proposing fixes.
---

# Systematic Debugging

## The Iron Law

```
NO FIXES WITHOUT ROOT CAUSE INVESTIGATION FIRST
```

If you haven't completed Phase 1, you cannot propose fixes.

## When to Use

Use for ANY technical issue — test failures, production bugs, unexpected behavior, performance problems, build failures, integration issues.

## The Phases

### Phase 1: Root Cause Investigation

1. **Reproduce Consistently**
   - Can you trigger it reliably?
   - What are the exact steps?
   - Does it happen every time?
   - If not reproducible, gather more data -- don't guess

2. **Check Recent Changes**
   - What changed that could cause this?
   - Git diff, recent commits
   - New dependencies, config changes
   - Environmental differences

3. **Gather Evidence in Multi-Component Systems**

   **WHEN system has multiple components (CI -> build -> signing, API -> service -> database):**

   **BEFORE proposing fixes, add diagnostic instrumentation:**
   ```
   For EACH component boundary:
     - Log what data enters component
     - Log what data exits component
     - Verify environment/config propagation
     - Check state at each layer

   Run once to gather evidence showing WHERE it breaks
   THEN analyze evidence to identify failing component
   THEN investigate that specific component
   ```

4. **Check Investigation History**
   - Search git log and any prior investigation notes for bugs in the same files
   - Recurring bugs in the same area are an architectural smell, not just bad luck
   - If prior investigations exist on these files, note the pattern — the root cause may be structural
   - If the codebase records prior architectural or scope decisions (e.g. in `docs/plans/` overviews or design docs), treat them as settled with their stated rationale. Don't silently re-litigate a settled call mid-fix; if your root-cause analysis implies reversing one, say so explicitly and surface it as a decision for the user rather than quietly changing direction

5. **Trace Data Flow**

   **WHEN error is deep in call stack:**

   See [root-cause-tracing.md](references/root-cause-tracing.md) for the complete backward tracing technique.

   **Quick version:**
   - Where does bad value originate?
   - What called this with bad value?
   - Keep tracing up until you find the source
   - Fix at source, not at symptom

### Phase 2: Hypothesis Testing

**Scientific method:**

1. **Form Single Hypothesis**
   - State clearly: "I think X is the root cause because Y"
   - Write it down
   - Be specific, not vague

2. **Test Minimally**
   - Make the SMALLEST possible change to test hypothesis
   - One variable at a time
   - Don't fix multiple things at once

3. **Verify Before Continuing**
   - Did it work? Yes -> Phase 3
   - Didn't work? Form NEW hypothesis
   - DON'T add more fixes on top

4. **When You Don't Know**
   - Say "I don't understand X"
   - Don't pretend to know
   - Ask for help
   - Research more

### Phase 3: Implementation

**Fix the root cause, not the symptom:**

1. **Create Failing Test Case**
   - Simplest possible reproduction
   - Automated test if possible
   - One-off test script if no framework
   - MUST have before fixing
   - Use the tdd skill for writing proper failing tests

2. **Implement Single Fix**
   - Address the root cause identified
   - ONE change at a time
   - No "while I'm here" improvements
   - No bundled refactoring
   - See `docs/principles/surgical-changes.md` — every changed line should trace to the fix

3. **Verify Fix**
   - Test passes now?
   - No other tests broken?
   - Issue actually resolved?

4. **If Fix Doesn't Work**
   - STOP
   - Count: How many fixes have you tried?
   - If < 3: Return to Phase 1, re-analyze with new information
   - **If >= 3: STOP and question the architecture (step 5 below)**
   - DON'T attempt Fix #4 without architectural discussion

5. **If 3+ Fixes Failed: Question Architecture**

   **Pattern indicating architectural problem:**
   - Each fix reveals new shared state/coupling/problem in different place
   - Fixes require "massive refactoring" to implement
   - Each fix creates new symptoms elsewhere

   **STOP and question fundamentals:**
   - Is this pattern fundamentally sound?
   - Are we "sticking with it through sheer inertia"?
   - Should we refactor architecture vs. continue fixing symptoms?

   **Discuss with the user before attempting more fixes**

   This is NOT a failed hypothesis - this is a wrong architecture.

6. **Escalation Permission**

   Bad work is worse than no work. It is always acceptable to stop and say "this is beyond what I can verify" or "I'm not confident in this result."

   - If you are uncertain about a security-sensitive change, STOP and escalate
   - If the scope of work exceeds what you can verify, STOP and escalate
   - If a fix seems to work but you cannot explain *why*, that is not a fix
   - A claimed blocker is itself a hypothesis: before escalating "this can't be done" or "this needs X", hold the verbatim error, the documented statement, or a live probe that proves it — when a cheap probe settles the question, run it first (`docs/principles/prove-it-works.md`)

   See `docs/principles/never-block-on-the-human.md`.

## Circles Detection

If you notice you're going in circles — repeating the same diagnostic, re-reading the same file, or trying variants of a failed fix — STOP and reassess. You are likely missing context or fighting the wrong abstraction. (This is thrashing on a *defect*, not a measurement plateau in an optimization loop — the latter calls for a pivot, not a stop; see the `hillclimb` skill.) Step back and:
- Re-read the error from scratch with fresh eyes
- Question whether you're investigating the right layer
- Consider whether the architecture itself is the problem (see Phase 3, step 5)

## Supporting References

- [root-cause-tracing.md](references/root-cause-tracing.md) - Trace bugs backward through call stack to find original trigger
- [defense-in-depth.md](references/defense-in-depth.md) - Add validation at multiple layers after finding root cause
- [condition-based-waiting.md](references/condition-based-waiting.md) - Replace arbitrary timeouts with condition polling
