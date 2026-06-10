# Principles

**How to read this index:** read the **Always read** baseline on every task. Then read in full each principle whose **Apply when** clause matches the task at hand — the [routing matrix](#routing-matrix) covers common task shapes. Read the whole corpus only when genuinely unsure which apply.

## Always read

- [Prove It Works](./prove-it-works.md) — verify the real thing directly, not proxies or self-reports. Every task ends with verification.
- [Surgical Changes](./surgical-changes.md) — every changed line traces to the request; clean up only your own orphans. Applies whenever editing existing code.

## Core

- [Foundational Thinking](./foundational-thinking.md) — data structures first, scaffold first, optimize for option value. **Apply when** starting a feature or component: choosing core types, sequencing scaffold vs features, deciding what concurrent actors share.
- [Redesign from First Principles](./redesign-from-first-principles.md) — redesign as if the new requirement existed from day one. **Apply when** integrating a new requirement into an existing design.
- [Subtract Before You Add](./subtract-before-you-add.md) — remove complexity first, then build. **Apply when** sequencing an addition, refactor, or rewrite — and continuously when sizing a diff or tempted to add abstraction.
- [Experience First](./experience-first.md) — the user experience is the product. **Apply when** making product, UX, or feature-scope trade-offs.
- [Exhaust the Design Space](./exhaust-the-design-space.md) — explore 2-3 alternatives before committing. **Apply when** facing a novel design or architectural decision with no established precedent.

## Architecture

- [Module Depth](./module-depth.md) — prefer deep modules: small interfaces hiding large implementations. **Apply when** designing interfaces, APIs, or package boundaries, or when existing code is hard to trace.
- [Boundary Discipline](./boundary-discipline.md) — validate at system boundaries, trust internal code. **Apply when** wiring validation, error handling, or framework adapters.
- [Make Operations Idempotent](./make-operations-idempotent.md) — operations converge to correct state regardless of reruns. **Apply when** designing operations that run amid crashes, retries, or reruns: migrations, deploys, startup, scheduled jobs.
- [Serialize Shared State Mutations](./serialize-shared-state-mutations.md) — enforce serialization structurally for concurrent access. **Apply when** concurrent actors can write the same state: a file, row, key, or branch.
- [Threat Modeling](./threat-modeling.md) — enumerate adversarial actors and trust boundaries; build defenses into the design. **Apply when** code crosses a trust boundary, touches authorization, or handles state an adversary can influence.
- [Observability](./observability.md) — design systems to emit structured signal so production behavior is queryable, not guessed. **Apply when** building or changing anything that runs in production: services, jobs, contracts emitting events.

## Verification

- [Fix Root Causes](./fix-root-causes.md) — never paper over symptoms, trace to root cause. **Apply when** debugging any failure, before proposing a fix.
- [Stop on Ambiguity](./stop-on-ambiguity.md) — when high-stakes ambiguity surfaces, name it and ask before proceeding. **Apply when** an irreversible fork or high-stakes ambiguity surfaces mid-task.
- [Build the Lever](./build-the-lever.md) — build the tool that does or proves the work; the tool is the artifact a reviewer reruns. **Apply when** work is non-trivial and a script, codemod, or generator would make it checkable or materially safer than hand edits.

(Prove It Works and Surgical Changes also belong here — they live in the Always-read baseline above.)

## Delegation

- [Guard the Context Window](./guard-the-context-window.md) — context is finite and non-renewable; route bulk to subagents, keep summaries in the main thread. **Apply when** context is filling up: large outputs, long files, repeated reads, fan-out planning.
- [Never Block on the Human](./never-block-on-the-human.md) — proceed on reversible execution, present results for async review; block on direction and irreversibility. **Apply when** tempted to ask "should I do X?" about reversible execution mid-task.

## Meta

- [Encode Lessons in Structure](./encode-lessons-in-structure.md) — encode recurring fixes in mechanisms, not textual instructions. **Apply when** writing the same instruction a second time, or after any recurring mistake.

## Routing matrix

Beyond the baseline, common task shapes route to:

| Task shape | Read |
|---|---|
| New feature / component | foundational-thinking, module-depth, experience-first |
| Refactor / cleanup | subtract-before-you-add, redesign-from-first-principles, module-depth |
| Bug fix / debugging | fix-root-causes |
| Security-sensitive: auth, trust boundaries, smart contracts | threat-modeling, boundary-discipline, stop-on-ambiguity |
| Concurrency / shared state | serialize-shared-state-mutations, make-operations-idempotent |
| Interface / API design | module-depth, exhaust-the-design-space, boundary-discipline |
| Production service / job / deploy change | observability, make-operations-idempotent |
| Novel architecture, no precedent | exhaust-the-design-space, foundational-thinking, redesign-from-first-principles |
| Sweep / migration / bulk edit | build-the-lever, make-operations-idempotent, subtract-before-you-add |
| Long, autonomous, or multi-session run | guard-the-context-window, never-block-on-the-human |

A task matching multiple rows reads the union. High-stakes rows (security, concurrency) are non-optional when their shape matches — skipping governance there is the failure mode this matrix exists to prevent.
