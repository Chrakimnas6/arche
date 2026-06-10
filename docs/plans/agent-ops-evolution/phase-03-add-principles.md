# Phase 3 — Add three agent-era principles (one PR)

← [Overview](./overview.md)

**Depends on Phase 0** (reverse set-equality check, so an unregistered principle fails CI) **and Phase 2** (relaxed bar + new category). Ship as **one PR**: all three principles share `index.md`, `EXPECTED_PRINCIPLES`, and the README category list, so they are not parallel-independent and splitting them would create merge conflicts on the same lines. This is a deliberate, documented exception to the ≤3-files phase-sizing rule — atomic registration is correct here.

## Goal

Add the three agent-era operating principles arche lacks, under a new **Delegation** category in `index.md`.

## Changes

- **New `docs/principles/guard-the-context-window.md`** — context is finite and non-renewable within a session; route bulk/large payloads to subagents and keep summaries in the main thread; don't read what you won't use; keep frequently-used templates inline; size phases and cap scope. Distinct from `module-depth`/`minimize-reader-load` (those are *human* reader load in code; this is the *agent's* working context).
- **New `docs/principles/build-the-lever.md`** — for non-trivial work, build the tool that does or *proves* it (codemod/script/generator) so a reviewer can rerun it. **Narrowed** (per review): the bar is "is the lever what makes this checkable or materially safer," **reuse existing tools first**, and the explicit balance clause "**triviality, not repetition**" — a one-off can still earn a lever, but don't institutionalize machinery larger than the task. Distinct from `encode-lessons-in-structure` (durable guardrail for a *recurring* instruction) and `subtract-before-you-add` (don't build a framework).
- **New `docs/principles/never-block-on-the-human.md`** (reconciled) — proceed on reversible execution and present for after-the-fact review; **block** on product/design direction and irreversible actions (force-push to shared branches, deleting data, external/customer messages, deploys). A mandatory "Relationship" section links `stop-on-ambiguity` and states the split in one sentence: block on design/requirements ambiguity, proceed on reversible execution. (Mirror this split into the owner's global files — tracked in Phase 1's global sync.)
- **Registration (all three):** add to `index.md` under a new **Delegation** category (with triggers per Phase 1's format) — `guard-the-context-window` and `never-block-on-the-human` are Delegation; `build-the-lever` goes under **Verification**. Add all three to `EXPECTED_PRINCIPLES`. Add the Delegation category + entries to the README category list (no count — removed in Phase 0).

## Key shapes

- Each file follows the existing principle anatomy: title, thesis, "Apply when" trigger (Phase 1 format), pattern bullets, "Relationship to Other Principles," Citations.

## Verification

**Static:** `bash tests/validate-setup.sh` green — Phase 0's reverse check now requires all three be registered (this is the phase that proves Phase 0 works). lychee resolves new cross-links (`build-the-lever` → `subtract-before-you-add`/`encode-lessons-in-structure`; `never-block-on-the-human` → `stop-on-ambiguity`).

**Runtime:** Manual read — each principle gives an actionable heuristic, not a slogan; `build-the-lever`'s balance clause is present (it must not read as "always build a tool"); `never-block-on-the-human`'s Boundaries section unambiguously classes force-push/deploy/customer-message as block and write-code/edit-notes as proceed.
