# Subtract Before You Add

**Principle:** When evolving a system, remove complexity first, then build on the simpler base. Migrate callers and delete legacy APIs in the same wave; converge directly on the target state rather than preserving every intermediate one.

## Pattern

- **Sequence removal before construction.** In plans, deletion phases come before build phases.
- **Cut before you polish.** Scope the feature set to the minimum before investing in quality; half-finished features are worse than missing ones.
- **Design for observed usage.** If the real workflow is single-process or low-concurrency, fit that; add edge-case machinery only after usage shows the need.
- **Delete a reference with no novel content** rather than leaving a stub.
- **Borrow a maintainer's fatigue.** Writing code is cheap for an agent, so over-engineering is easy. When asked to improve, prefer deletion; make the smallest change that solves the problem; when a task wants a new signal threaded through types, schemas, or pipelines, stop and look for a more direct path. If a human would find the result exhausting to maintain, it's a bad solution.
- **Sweat the small leaks.** In code you are already changing, remove tiny pass-throughs, representation leaks, and duplicated decisions before they spread; leave it slightly simpler, behind the same or smaller surface. Code you aren't changing is [surgical-changes](./surgical-changes.md) territory.

**Climb the reuse ladder before writing new code.** Stop at the first rung that holds:

1. Does this need to exist at all? Name what you skip in one line; a vague request gets the smallest version that does the core job.
2. Does the codebase already have it? Reuse it the way the surrounding code does.
3. Does the standard library or platform do it? Unless the codebase has its own; the house version wins.
4. Does an already-installed dependency solve it? Never add a dependency for a few lines.
5. Can it be one line a reader gets at a glance?
6. Only then: write the minimum that works.

Climb it after reading the code the change touches, not instead of it, and after listing every place the change must reach (callers, tests, fixtures, config, exports): be lazy about the solution, never about the change. It never cuts what correctness requires: trust-boundary validation, error handling that prevents data loss, security, accessibility.

## Migrate Callers, Then Delete Legacy APIs

When a new API is the right design, inventory the callers, migrate them, and delete the old API in the same wave. Don't keep a legacy path alive because internal callers still exist; temporary adapters are exceptional and time-boxed. Update tests to assert the new contract and delete tests that only protect pre-refactor implementation details.

**Applies when** no external users depend on backward compatibility and the project can absorb a coordinated breaking change. Code you move or merge keeps its validation and error handling.

## Converge to the End State

In planned rewrites and migrations with explicit phase boundaries, converge on the target architecture instead of keeping every intermediate step green with compatibility code that outlives the migration.

- Declare where temporary breakage is acceptable and where it is not; it must be planned, scoped, and reversible.
- Keep high-signal checks on actively touched areas while migrating.
- Full static and runtime verification at completion is non-negotiable.
