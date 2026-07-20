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

### 1. Ground the workload before choosing the ruler

Before building the harness, name the realistic workload dimensions that can move the result — data size, history depth, state, concurrency — and pick a case that reproduces the user's actual complaint. If no case reproduces it, you have a repro problem, not a hillclimb: fix the repro first. Optimizing a workload nobody hits produces green numbers and an unchanged experience.

Read the actual architecture at the same time, so hypotheses in step 3 name a specific mechanism, not folklore.

### 2. Build the harness, prove its sensitivity, then freeze it

Build the harness that produces the metric — a script, benchmark, or test you can rerun identically. Before trusting it, **prove it is sensitive**: run contrasting realistic workloads and confirm the target case shows the symptom while easier cases separate as expected. A ruler that can't distinguish a slow case from a fast one can't measure a win. If it can't, revise the workload or the metric before proceeding.

Once proven, the harness is your **immutable ruler**: if it changes mid-run, no measurement is comparable. It is the artifact a reviewer reruns to replay your run. See `docs/principles/build-the-lever.md`.

Record the **baseline** measurement before changing anything. Fix an **attempt budget** for the run at the same time — use the one the user gave, or declare one at the top of the decision log and proceed (adjustable on async review).

### 3. One hypothesis, grounded in the system

Each attempt states a hypothesis: "Changing X should move the metric because Y," naming a specific mechanism in the architecture you read in step 1 ("defer X off the boot path because it blocks first paint"), not "try memoizing something."

Most performance wins come from a small set of **strategy families**. Use them to generate hypotheses, not as a checklist — a family earns an attempt only when the measurement shows the signal it names, and a focused fix for the dominant cost beats spreading effort across all of them.

- **Elimination.** The cheapest work is work that never runs. Before optimizing a hot path, ask whether it needs to exist: a result nobody consumes, a gate always off for this case, a redundant sync. Deleting the work beats every other family when it applies — and the measurement shows what's slow, never that it's deletable, so this one needs reading the code, not just the profile.
- **Divide and conquer.** Cost scales with input size. Split so each piece touches less (chunk, shard, prune the search space) or so independent pieces run in parallel.
- **Caching.** The same computation or fetch repeats on identical inputs. Store and reuse — and name what invalidates it before claiming the win.
- **Indirection.** Add a cheaper intermediate the hot path can lean on: an index instead of a scan, a queue that moves work off the interactive path. Add the hop only when it removes more from the critical path than it adds.
- **Batching.** Many small operations each pay a fixed overhead (RPC, query, syscall). Coalesce them to pay it once per batch.
- **Redundancy.** The wait hangs on one slow instance. Duplicate the work (replicas, hedged requests) and take the fastest — only when the measurement shows the wait dominates and there's headroom, since this trades load for tail latency.
- **Lazy evaluation.** Cost lands on results never used or not needed yet (eager init on the boot path). Defer until first use.
- **Scheduling.** The work must happen, but not now: move it to idle time, a background warmup, or precompute before the user arrives. Distinct from lazy — scheduling often runs the work *earlier*, in the hot moment's shadow. The win is perceived latency, so measure the interactive path, not total work done.

### 4. One change, measure, keep or revert

- Make the **smallest** change that tests the hypothesis.
- Re-run the frozen harness. Compare against baseline.
- **Keep** only if it beats noise *and* regression tests stay green. Otherwise **revert** — cleanly, leaving no orphan changes (`docs/principles/surgical-changes.md`).
- Measure the real metric; never accept a win from code inspection (`docs/principles/prove-it-works.md`).

One commit per accepted win, staged files only. Run parallel attempts in separate worktrees so they don't contaminate each other's measurements.

### 5. Keep a decision log

Maintain a log with one row per attempt so a reviewer can replay the run:

```
id | hypothesis | change | before | after | delta | tests | verdict (kept/reverted) | note
```

### 6. Stop semantics

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
