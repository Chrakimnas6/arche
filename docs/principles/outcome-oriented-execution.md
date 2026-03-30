# Outcome-Oriented Execution

**Principle:** Optimize for the intended, verifiable end state rather than preserving smooth intermediate states.

## Why

In large refactors and migrations, forcing every intermediate step to stay fully stable often creates temporary compatibility code that becomes long-lived debt. The cleaner strategy is to converge directly on the target architecture and prove correctness at explicit verification boundaries.

## Core Rule

- Prioritize end-state integrity over transitional stability.
- Intermediate breakage is acceptable when it is planned, scoped, and reversible.
- Final verification is non-negotiable.

## Guardrails

- Use this for planned rewrites/migrations with explicit phase boundaries.
- Declare where temporary breakage is acceptable and where it is not.
- Keep high-signal checks for actively touched areas while migrating.
- Require full static and runtime verification at plan completion.

In smart contracts, this principle applies to upgrade paths -- when migrating from v1 to v2 of a contract, design the v2 end state cleanly rather than contorting v1 to stay backward-compatible during the transition. Use migration scripts that converge on the target state and verify invariants at the end.

## Anti-Pattern

Preserving obsolete paths only to keep every intermediate step green when no long-term compatibility is needed.

## Relationship to Other Principles

This complements [subtract-before-you-add](./subtract-before-you-add.md) by making outcome-first sequencing explicit.
