---
name: execute-plan
description: >-
  Execute an implementation plan from docs/plans/ phase by phase, with each phase's
  verification gating the next. Use when asked to "implement the plan", "execute the plan",
  or to continue a partially-implemented plan.
---

# Execute Plan

Implement an existing plan from `docs/plans/<plan-name>/`, one phase at a time. The plan is the contract: phases run in order, and a phase is done only when its verification section passes.

## Step 1 — Load the Plan and Principles

Read the plan's `overview.md` and every phase file. Read `docs/principles/index.md`, then the principles the overview cites.

Determine where to start: check phase files for `Status: done` markers, then verify against the actual code — a marker is a claim, the code is the evidence. Resume from the first unfinished phase and state which phases you consider already done.

## Step 2 — Execute Phases in Order

For each phase:

1. **Re-read the phase file.** Its Goal, Changes, and Data structures sections are the brief.
2. **Implement.** Use the `tdd` skill when the phase adds testable behavior. Stay surgical (`docs/principles/surgical-changes.md`) — only what the phase describes, nothing opportunistic.
3. **Verify.** Run the phase's verification section — both static and runtime checks. "It compiles" is not verification (`docs/principles/prove-it-works.md`).
4. **Gate.** Do not start the next phase until this phase's verification passes. If it fails, use the `investigate` skill — no quick patches to reach the next phase.
5. **Record completion.** Add a `Status: done` line at the top of the phase file so a future session can resume without re-deriving progress.

### Delegating the Implement step

When an `implementer` agent is available, delegate step 2 to it instead of implementing inline — implementation churn (file reads, failed test iterations) stays in the worker's disposable context while this session keeps a clean phase-level view (`docs/principles/guard-the-context-window.md`):

- **One phase per delegation** — brief granularity has an optimum; don't split finer. The brief is the phase file plus the overview context the worker can't discover itself. Skip delegation for a trivial phase where writing the brief costs more than the change.
- **Escalate deliberately.** The worker's default model fits mechanical phases; for a design-heavy phase, override the model on that one invocation rather than changing the default.
- **Gate on artifacts, not self-reports.** Re-run the phase's Verification yourself and review the diff before starting the next phase.
- **Keep design judgment here.** If the worker reports a divergence or its verification fails twice, take over in the main loop — don't re-delegate blindly.
- **The worker never touches plan files.** Transcribe decisions from its report into the phase file's `## Decisions` section and write the `Status: done` marker yourself.

## Divergence Rule

When reality contradicts the plan — an approach doesn't work, a file the plan assumed doesn't exist, a materially better design surfaces mid-phase — STOP. Do not silently improvise. Update the plan files to match the new understanding and tell the user what changed and why; if the divergence forks the design, ask before proceeding (`docs/principles/stop-on-ambiguity.md`). The plan must stay truthful: a completed plan that doesn't describe what was built is worse than no plan.

Below that bar — a reversible call the plan is simply silent on (edge-case behavior, the shape of an internal helper) — don't stop: decide in line with the plan's intent and keep going (`docs/principles/never-block-on-the-human.md`). If the why wouldn't be evident from the diff, add a one-line entry under a `## Decisions` heading in the current phase file; diff-visible choices like naming need no entry.

## Step 3 — Close Out

After the final phase:

1. Run the overview's project-level Verification commands.
2. Summarize what was built per phase, every divergence from the original plan, and each phase file's `## Decisions` entries.
3. Suggest `pre-landing-review` — preferably in a fresh session, since this session authored the diff and a reviewer carrying the author's reasoning misses what the author never considered — plus `adversarial-review` for large or high-stakes diffs (its external reviewers get fresh context by construction), then `reflect`.
4. Suggest deleting the plan directory once the work has landed — a completed plan left in `docs/plans/` reads as live guidance while git already preserves it. Salvage any still-forward-looking decisions to `docs/design/` first.
