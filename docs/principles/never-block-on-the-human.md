# Never Block on the Human

**Principle:** The human supervises asynchronously. Proceed on reversible execution and present the result for review; reserve blocking for product/design direction, irreversible actions, and high-stakes ambiguity.

**Apply when** tempted to ask "should I do X?" about reversible execution mid-task, or when a fork surfaces and you must decide whether it warrants stopping.

## Why

Every unnecessary permission pause makes the human the pipeline's bottleneck. Code changes are reviewable and revertible: a wrong implementation costs minutes to redo, while a blocked agent costs the human's attention to unblock — usually the scarcer resource. Asynchronous supervision (review the diff afterward) preserves both throughput and control.

The exception is the case where guessing wrong is far more expensive than pausing to ask — direction, one-way doors, unresolved high-stakes ambiguity. There, bad work is worse than no work.

## The Pattern

- **Proceed, then present.** Do the reversible work, show the result, explain the choice. Don't ask permission to execute what was already agreed.
- **Prefer the experiment over the question.** If the answer is observable by running something (behavior, output, timing), run it and present the result — don't make the human decide what an experiment can settle.
- **Reserve questions for genuine forks.** Ask only when intent cannot be inferred and the options differ in ways only the owner can weigh.
- **Design for review-after-the-fact.** Leave a legible trail (clear diffs, commit messages, notes) so async review is cheap.
- **Mid-run discoveries are yours.** On a long or autonomous run, the problems you stumble into — a broken skill, a flaky verifier, a related bug, a tooling failure, an orphaned follow-up, fixable drift — are yours to fix in the same loop, not to park for the human. Keep the out-of-band fix in its own commit or PR so it doesn't muddy the scope you were asked for (see [surgical-changes](./surgical-changes.md)), then return to the main objective. Surface, don't self-serve, only the irreversible actions and genuine forks the boundaries below reserve.

## Boundaries

**Proceed on reversible execution:** writing code, editing docs, running tests, local refactors, exploration. Routine coding, small features, and obvious changes; decisions where constraints dictate a single viable approach; mechanical implementation where the pattern is established.

**Block on:**

- **Direction** — what to build, product/UX trade-offs, scope changes: anything where a wrong guess wastes the work, not just the minutes.
- **Irreversible actions** — force-pushing shared branches, deleting data, sending external messages, deploys, publishing; and any destructive operation whose scope is unclear.
- **High-stakes ambiguity** — two plausible architectures or data models for the same requirement; a request that contradicts existing patterns and you're unsure which to follow; missing context that would change your approach significantly; a security-sensitive change you're uncertain about.
- **Exhausted attempts** — you have attempted a task 3 times without success, or the scope of work exceeds what you can verify.

**When you block:** name the ambiguity in one sentence, present 2-3 options with trade-offs, ask before proceeding. It is always acceptable to stop and say "I'm not confident in this decision" or "this is beyond what I can verify." Language-specific applications (e.g., contract storage layout) live in [docs/applications/](../applications/).

## Relationship to Other Principles

[Prove it works](./prove-it-works.md) is what makes proceeding safe — present *verified* results, not claims.

[Exhaust the design space](./exhaust-the-design-space.md) governs deliberate exploration at design time; this principle governs ambiguity that surfaces unexpectedly mid-implementation — proactive exploration vs. reactive detection.

## Citations

Agent-era operating principle (consensus-backed, per the promotion bar's authoritative-backing branch): Osmani, "Loop Engineering" (addyosmani.com, 2026) — asynchronous supervision of agent loops; "your job is to ship code you confirmed works." pstack, `principle-never-block-on-the-human` (cursor/plugins) — an independent implementation, including the reversible/irreversible boundary. On the stopping half: Toyota Production System's andon cord — "stop the line on any defect" — see Liker, *The Toyota Way* (McGraw-Hill, 2004), and Imai, *Kaizen* (McGraw-Hill, 1986); Hunt & Thomas, *The Pragmatic Programmer* (20th Anniversary Edition, 2019), Topic 27, "Don't outrun your headlights."
