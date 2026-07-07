---
name: hillclimb
description: Iterative optimization of one measurable metric toward a target via keep-or-revert experiments. Use when sustainedly improving a metric (latency, gas cost, throughput, accuracy, bundle size) against a goal — not when debugging a defect (use investigate) or building a feature (use tdd).
---

# Hillclimb

Sustained, scientific improvement of **one metric** against a **target**. You own the metric and the experiment's integrity: supervise and review, delegate the attempts.

## The Iron Law

```
ONE CHANGE, ONE MEASUREMENT, KEEP OR REVERT.
```

Never stack untested changes. Never claim a win from reading the code — only a measurement counts.

## When to Use

Use when the goal is a number moving toward a target over many iterations:
- Latency, throughput, gas/transaction cost, memory, bundle size, accuracy, pass rate.

**Don't use for:**
- Debugging a defect → use `investigate` (find one root cause, fix, stop).
- Building a feature → use `tdd`.
- A single known optimization → just make it and verify; you don't need a loop.

## The Loop

### 1. Freeze the measurement harness first

Before any attempt, build the harness that produces the metric — a script, benchmark, or test you can rerun identically. This is your **immutable ruler**: if the ruler changes mid-run, no measurement is comparable. The harness is the artifact a reviewer reruns to replay your run. See `docs/principles/build-the-lever.md`.

Record the **baseline** measurement before changing anything. Fix an **attempt budget** for the run at the same time — use the one the user gave, or declare one at the top of the decision log and proceed (adjustable on async review).

### 2. One hypothesis, grounded in the system

Read the actual architecture before guessing. Each attempt states a hypothesis: "Changing X should move the metric because Y." Ground it in how the system actually works, not in folklore.

### 3. One change, measure, keep or revert

- Make the **smallest** change that tests the hypothesis.
- Re-run the frozen harness. Compare against baseline.
- **Keep** only if it beats noise *and* regression tests stay green. Otherwise **revert** — cleanly, leaving no orphan changes (`docs/principles/surgical-changes.md`).
- Measure the real metric; never accept a win from code inspection (`docs/principles/prove-it-works.md`).

One commit per accepted win, staged files only. Run parallel attempts in separate worktrees so they don't contaminate each other's measurements.

### 4. Keep a decision log

Maintain a log with one row per attempt so a reviewer can replay the run:

```
id | hypothesis | change | before | after | delta | tests | verdict (kept/reverted) | note
```

### 5. Stop semantics

Stop **only** when: the predicate is met (metric hits target), remaining ideas lack meaningful cost-benefit, or the attempt budget is exhausted — then keep the best accepted state and present the decision log. A budget stop is a defined outcome, not a failure. The budget bounds the whole run, pivots included; it never licenses quitting at the first plateau.

**A plateau is not a stop.** Two flat iterations mean *pivot the approach*, not *quit*: pivot category, combine near-misses, re-read the source, or try something more radical. Surface a genuine dead end honestly rather than spinning on variants of a failed attempt.

> This is the inverse of `investigate`'s Circles Detection: there, repetition on a *failed fix* means stop and reassess. Here, a *measurement plateau* in an optimization loop means pivot and push past it. Don't confuse thrashing (stop) with plateauing (pivot).

## Red Flags — STOP

- Stacking several untested changes, then measuring once.
- "This should be faster" kept without a before/after measurement.
- Editing the harness mid-run so old numbers no longer compare.
- Reverting nothing — accumulating dead experiments in the tree.
- Quitting at the first plateau instead of pivoting.

## Relationship to Principles

- `build-the-lever` — the frozen harness *is* the lever; it does and proves the work.
- `prove-it-works` — measure the real metric, never a proxy or a code-inspection guess.
- `never-block-on-the-human` — run the loop autonomously; present the decision log for async review rather than asking per-attempt.
