# Principles

## Core

- [Foundational Thinking](./foundational-thinking.md) — data structures first, scaffold first, optimize for option value
- [Redesign from First Principles](./redesign-from-first-principles.md) — redesign as if the new requirement existed from day one
- [Subtract Before You Add](./subtract-before-you-add.md) — remove complexity first, then build
- [Outcome-Oriented Execution](./outcome-oriented-execution.md) — optimize for the intended end state, not smooth intermediates
- [Experience First](./experience-first.md) — the user experience is the product
- [Exhaust the Design Space](./exhaust-the-design-space.md) — explore 2-3 alternatives before committing

## Architecture

- [Boundary Discipline](./boundary-discipline.md) — validate at system boundaries, trust internal code
- [Make Operations Idempotent](./make-operations-idempotent.md) — operations converge to correct state regardless of reruns
- [Migrate Callers Then Delete Legacy APIs](./migrate-callers-then-delete-legacy-apis.md) — migrate and remove in the same wave
- [Serialize Shared State Mutations](./serialize-shared-state-mutations.md) — enforce serialization structurally for concurrent access

## Verification

- [Prove It Works](./prove-it-works.md) — verify the real thing directly, not proxies or self-reports
- [Fix Root Causes](./fix-root-causes.md) — never paper over symptoms, trace to root cause
- [Confusion Protocol](./confusion-protocol.md) — STOP on high-stakes ambiguity, present options, ask

## Meta

- [Encode Lessons in Structure](./encode-lessons-in-structure.md) — encode recurring fixes in mechanisms, not textual instructions
