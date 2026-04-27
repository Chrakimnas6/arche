# Subtract Before You Add

**Principle:** When evolving a system, remove complexity first, then build. Deletion creates a simpler substrate that makes subsequent additions cleaner, smaller, and less error-prone. The corollaries: migrate callers and delete legacy APIs in the same wave; converge directly on the target state rather than preserving every intermediate state.

## Why

Adding to a complex system compounds complexity. Removing first reduces the surface area, reveals the essential structure, and makes the addition's design more obvious. The default action should be subtraction. The principle generalizes to *ordering*: subtract first, then build; migrate callers before deleting an old API; converge to the end state without paying the cost of indefinite intermediate compatibility.

## The Pattern

- **Sequence removal before construction.** In plans, schedule deletion phases before build phases. Each piece of dead code, unused feature, or unnecessary abstraction removed makes the subsequent work simpler.
- **Cut before you polish.** When scoping a feature set, cut ruthlessly to the minimum before investing in quality. Half-finished features are worse than missing ones.
- **Design for observed usage, not speculative edge cases.** If the real workflow is single-process or low-concurrency, prefer simpler designs that fit that reality. Add edge-case machinery only after usage data says it's needed.
- **When a reference has no novel content, delete it** rather than leaving a stub.

## Migrate Callers, Then Delete Legacy APIs

When a new API is the right design, migrate callers and remove the old API in the *same* refactor wave instead of preserving compatibility layers.

- Do not keep legacy API paths alive just because internal callers still exist.
- Inventory callers, migrate them, and delete the old API immediately.
- Treat temporary adapters as exceptional and time-boxed, not default architecture.
- Update tests to assert the new contract; delete tests that only protect pre-refactor implementation details.

**When this applies:** no external users depend on backward compatibility, the project can absorb coordinated breaking changes, and the new API is part of a simplification/refactor initiative. Keeping both old and new APIs creates dual-path complexity, slows cleanup, and makes the codebase feel append-only.

## Converge to the End State

Optimize for the intended, verifiable end state rather than preserving smooth intermediate states.

- **Prioritize end-state integrity** over transitional stability.
- **Intermediate breakage is acceptable** when it is planned, scoped, and reversible.
- **Final verification is non-negotiable.**

In large refactors and migrations, forcing every intermediate step to stay fully stable often creates temporary compatibility code that becomes long-lived debt. The cleaner strategy is to converge directly on the target architecture and prove correctness at explicit verification boundaries.

**Guardrails.** Use this for planned rewrites/migrations with explicit phase boundaries. Declare where temporary breakage is acceptable and where it is not. Keep high-signal checks for actively touched areas while migrating. Require full static and runtime verification at plan completion.

**Anti-pattern:** preserving obsolete paths only to keep every intermediate step green when no long-term compatibility is needed.

Language-specific applications live in [docs/applications/](../applications/).

## Relationship to Other Principles

This is not about *what* to build ([foundational-thinking](./foundational-thinking.md)) or *how* to redesign it ([redesign-from-first-principles](./redesign-from-first-principles.md)). It's about *when* to act — an ordering principle that says subtraction comes before addition, migration comes before deletion, and the end state comes before transitional stability.

## Citations

Saint-Exupéry, *Wind, Sand and Stars* (1939) — "Perfection is finally attained not when there is no longer anything to add, but when there is no longer anything to take away." Brooks, *The Mythical Man-Month* (1975) — second-system effect; less is more. Hunt & Thomas, *The Pragmatic Programmer* (1999) — "Programming Deliberately" + DRY's converse: dead code is worse than no code. Fowler, *Refactoring* (2nd ed., 2018) — strangler fig pattern for caller migration; refactor in the direction of deletion.
