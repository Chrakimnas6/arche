---
name: hillclimb
description: Iterative optimization of one measurable metric toward a target via keep-or-revert experiments. Use when sustainedly improving a metric (latency, gas cost, throughput, accuracy, bundle size) against a goal — not when debugging a defect or building a feature.
---

# Hillclimb

Sustained, scientific improvement of **one metric** against a **target**. You own the metric and the experiment's integrity: supervise and review, delegate the attempts.

## The Loop

### 1. Ground the workload before choosing the ruler

Before building the harness, name the realistic workload dimensions that can move the result — data size, history depth, state, concurrency — and pick a case that reproduces the user's actual complaint. If no case reproduces it, you have a repro problem, not a hillclimb: fix the repro first. Optimizing a workload nobody hits produces green numbers and an unchanged experience.

Read the actual architecture at the same time, so hypotheses in step 3 name a specific mechanism, not folklore.

### 2. Build the harness, prove its sensitivity, then freeze it

Build the harness that produces the metric — a script, benchmark, or test you can rerun identically. Before trusting it, **prove it is sensitive**: run contrasting realistic workloads and confirm the target case shows the symptom while easier cases separate as expected. A ruler that can't distinguish a slow case from a fast one can't measure a win. If it can't, revise the workload or the metric before proceeding.

**Make the harness show the work happened.** Have it print an error count and a count of work done (rows written, calls that succeeded), so every keep-or-revert also proves the timed work happened and didn't fail. Run sides alternately (A, B, A, B) so warmup and drift favor neither; a gap inside run-to-run spread is no difference. Check each win against arithmetic: removing a piece that takes 10% of the run can't make it more than ~11% faster — a result past that limit measured a cache, a no-op, or a bug (`docs/principles/prove-it-works.md`, Measured numbers).

Once proven, the harness is your **immutable ruler**: if it changes mid-run, no measurement is comparable. It is the artifact a reviewer reruns to replay your run. See `docs/principles/build-the-lever.md`.

Record the **baseline** measurement before changing anything — sampled to clear the noise (median of N runs, never a single number) — plus a green run of the regression tests that must stay green, so a later failure is attributable. Record the **method** beside it — sample count, what one sample is, and run order — and the commit SHA it measured. Baseline and attempt must measure the **same scenario**: if the baseline cannot run it at all (the behavior doesn't exist yet at baseline), don't report a ratio between unlike runs — set an absolute budget for the work the change adds and for the end-to-end state the user waits for, and gate on those instead. Fix an **attempt budget** for the run at the same time — use the one the user gave, or declare one at the top of the decision log and proceed (adjustable on async review). Give the stop predicate a **floor on attempts** as well as a target, so a lucky early win can't end the run.

### 3. One hypothesis, grounded in the system

Each attempt states a hypothesis: "Changing X should move the metric because Y," naming a specific mechanism in the architecture you read in step 1 ("defer X off the boot path because it blocks first paint"), not "try memoizing something."

### 4. One change, measure, keep or revert

- Make the **smallest** change that tests the hypothesis.
- Re-run the frozen harness. Compare against baseline.
- **Keep** only if it beats noise *and* regression tests stay green. Otherwise **revert** — cleanly, leaving no orphan changes (`docs/principles/surgical-changes.md`).

One commit per accepted win, staged files only. Run parallel attempts in separate worktrees so they don't contaminate each other's measurements.

### 5. Keep a decision log

Maintain a log with one row per attempt so a reviewer can replay the run:

```
id | hypothesis | change | sha | before | after | delta | tests | verdict (kept/reverted) | note
```

### 6. Stop semantics

Stop **only** when: the predicate is met (metric hits target and the attempt floor is spent), remaining ideas lack meaningful cost-benefit, or the attempt budget is exhausted — then keep the best accepted state and present the decision log. A budget stop is a defined outcome, not a failure. The budget bounds the whole run, pivots included; it never licenses quitting at the first plateau.

**A plateau is not a stop.** Two flat iterations mean *pivot the approach*, not *quit*: pivot category, combine near-misses, re-read the source, or try something more radical. Surface a genuine dead end honestly rather than spinning on variants of a failed attempt.
