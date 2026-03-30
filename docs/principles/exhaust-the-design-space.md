# Exhaust the Design Space Before Committing

When facing a novel interaction or architectural decision with no established precedent, explore multiple concrete alternatives before committing to implementation. The cost of building the wrong thing dwarfs the cost of exploring three options.

## The Rule

For decisions where the right answer isn't obvious, build 2-3 competing prototypes or sketches. Compare them side-by-side. Only then commit.

## When It Applies

- Novel interactions (no prior art in the codebase)
- Architectural choices with multiple viable approaches
- Smart contract storage layout decisions where the wrong choice is permanent
- API surface design where downstream consumers depend on stability

## When It Doesn't

- Mechanical implementation where the pattern is established
- Bug fixes or refactors with a clear target state
- Changes where constraints dictate a single viable approach

After a direction is chosen, see [subtract-before-you-add](./subtract-before-you-add.md) for implementation discipline.

## Distinction from Other Principles

[Redesign from first principles](./redesign-from-first-principles.md) governs how to *integrate* a change. This governs how to *discover which change to make* when the answer isn't obvious. [Experience first](./experience-first.md) mentions prototyping as one tactic; this elevates design-space exploration to a decision-making principle.

See also [experience-first](./experience-first.md), [redesign-from-first-principles](./redesign-from-first-principles.md)
