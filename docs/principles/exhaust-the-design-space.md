# Exhaust the Design Space Before Committing

When facing a novel interaction or architectural decision with no established precedent, explore multiple concrete alternatives before committing to implementation. The cost of building the wrong thing dwarfs the cost of exploring three options.

## The Rule

For decisions where the right answer isn't obvious, build 2-3 competing prototypes or sketches. Compare them side-by-side. Only then commit.

**Design It Twice** (Ousterhout, "A Philosophy of Software Design"): your first idea is unlikely to be the best. For interface design specifically, explore radically different interfaces -- not variations on one theme. A second flavor of the first shape does not count as a second design. Contrast by depth (leverage at the interface), locality (where change concentrates), and seam placement. Screen every candidate against the [module-depth](./module-depth.md) red flags before committing, and between viable candidates prefer the one that hides more complexity behind a smaller, simpler interface.

**Coverage vs kind:** Alternatives usually differ in kind (fundamentally different architectures), not coverage (more vs less of the same thing). Compare on tradeoffs — performance, complexity, flexibility — not on a single completeness axis. Don't force-rank qualitatively different approaches with numerical scores; explain the tradeoff that matters for this specific decision.

## When It Applies

- Novel interactions (no prior art in the codebase)
- Architectural choices with multiple viable approaches
- API surface design where downstream consumers depend on stability
- Decisions that are hard to reverse after deployment

## When It Doesn't

- Mechanical implementation where the pattern is established
- Bug fixes or refactors with a clear target state
- Changes where constraints dictate a single viable approach

After a direction is chosen, see [subtract-before-you-add](./subtract-before-you-add.md) for implementation discipline.
