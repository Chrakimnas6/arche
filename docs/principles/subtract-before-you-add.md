# Subtract Before You Add

**Principle:** When evolving a system, remove complexity first, then build. Deletion creates a simpler substrate that makes subsequent additions cleaner, smaller, and less error-prone.

## Why

Adding to a complex system compounds complexity. Removing first reduces the surface area, reveals the essential structure, and makes the addition's design more obvious. The default action should be subtraction.

## The Pattern

- **Sequence removal before construction.** In plans, schedule deletion phases before build phases. Each piece of dead code, unused feature, or unnecessary abstraction removed makes the subsequent work simpler.
- **Cut before you polish.** When scoping a feature set, cut ruthlessly to the minimum before investing in quality. Half-finished features are worse than missing ones.
- **Design for observed usage, not speculative edge cases.** If the real workflow is single-process or low-concurrency, prefer simpler designs that fit that reality. Add edge-case machinery only after usage data says it's needed.
- **When a reference has no novel content, delete it** rather than leaving a stub.

Language-specific applications live in [docs/applications/](../applications/).

## Relationship to Other Principles

This is not about *what* to build ([foundational-thinking](./foundational-thinking.md)) or *how* to redesign it ([redesign-from-first-principles](./redesign-from-first-principles.md)). It's about *when* to act -- an ordering principle that says subtraction comes before addition.

## Citations

Saint-Exupéry, *Wind, Sand and Stars* (1939) — "Perfection is finally attained not when there is no longer anything to add, but when there is no longer anything to take away." Brooks, *The Mythical Man-Month* (1975) — second-system effect; less is more. Hunt & Thomas, *The Pragmatic Programmer* (1999) — "Programming Deliberately" + DRY's converse: dead code is worse than no code.
