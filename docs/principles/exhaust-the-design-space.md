# Exhaust the Design Space Before Committing

When facing a novel interaction or architectural decision with no established precedent, explore multiple concrete alternatives before committing to implementation. The cost of building the wrong thing dwarfs the cost of exploring three options.

## The Rule

For decisions where the right answer isn't obvious, build 2-3 competing prototypes or sketches. Compare them side-by-side. Only then commit.

**Design It Twice** (Ousterhout, "A Philosophy of Software Design"): your first idea is unlikely to be the best. For interface design specifically, explore radically different interfaces -- not variations on one theme. Contrast by depth (leverage at the interface), locality (where change concentrates), and seam placement. See [module-depth](./module-depth.md) for vocabulary.

## When It Applies

- Novel interactions (no prior art in the codebase)
- Architectural choices with multiple viable approaches
- API surface design where downstream consumers depend on stability
- Decisions that are hard to reverse after deployment

## When It Doesn't

- Mechanical implementation where the pattern is established
- Bug fixes or refactors with a clear target state
- Changes where constraints dictate a single viable approach

After a direction is chosen, see [subtract-before-you-add](./subtract-before-you-add.md) for implementation discipline. Language-specific applications live in [docs/applications/](../applications/).

## Distinction from Other Principles

[Redesign from first principles](./redesign-from-first-principles.md) governs how to *integrate* a change. This governs how to *discover which change to make* when the answer isn't obvious.

See also [redesign-from-first-principles](./redesign-from-first-principles.md), [module-depth](./module-depth.md).

## Citations

Ousterhout, *A Philosophy of Software Design* (2nd ed., 2021) — "Design It Twice." Brooks, *The Mythical Man-Month* (1975), chapter 11 "Plan to Throw One Away" — the first system informs the second.
