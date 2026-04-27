# Principles

## Core

- [Foundational Thinking](./foundational-thinking.md) — data structures first, scaffold first, optimize for option value
- [Redesign from First Principles](./redesign-from-first-principles.md) — redesign as if the new requirement existed from day one
- [Subtract Before You Add](./subtract-before-you-add.md) — remove complexity first, then build
- [Experience First](./experience-first.md) — the user experience is the product
- [Exhaust the Design Space](./exhaust-the-design-space.md) — explore 2-3 alternatives before committing

## Architecture

- [Module Depth](./module-depth.md) — prefer deep modules: small interfaces hiding large implementations
- [Boundary Discipline](./boundary-discipline.md) — validate at system boundaries, trust internal code
- [Make Operations Idempotent](./make-operations-idempotent.md) — operations converge to correct state regardless of reruns
- [Serialize Shared State Mutations](./serialize-shared-state-mutations.md) — enforce serialization structurally for concurrent access
- [Threat Modeling](./threat-modeling.md) — enumerate adversarial actors and trust boundaries; build defenses into the design
- [Observability](./observability.md) — design systems to emit structured signal so production behavior is queryable, not guessed

## Verification

- [Prove It Works](./prove-it-works.md) — verify the real thing directly, not proxies or self-reports
- [Fix Root Causes](./fix-root-causes.md) — never paper over symptoms, trace to root cause
- [Stop on Ambiguity](./stop-on-ambiguity.md) — when high-stakes ambiguity surfaces, name it and ask before proceeding

## Meta

- [Encode Lessons in Structure](./encode-lessons-in-structure.md) — encode recurring fixes in mechanisms, not textual instructions
