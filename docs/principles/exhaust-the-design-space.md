# Exhaust the Design Space Before Committing

**Principle:** When the right answer isn't obvious, build 2-3 competing prototypes or sketches, compare them side by side, and only then commit. Building the wrong thing costs far more than exploring three options.

- **Make the alternatives differ in kind.** For interfaces especially, explore radically different designs; a second flavor of the first shape does not count. Contrast them by depth (leverage at the interface), locality (where change concentrates), and seam placement.
- **Screen candidates against the [module-depth](./module-depth.md) red flags.** Between viable ones, prefer the one that hides more complexity behind a smaller interface.
- **Explain the trade-off; don't score it.** Compare on the trade-offs that matter for this decision (performance, complexity, flexibility). Don't force-rank qualitatively different approaches with numerical scores.

## When It Applies

- Novel interactions with no prior art in the codebase
- Architectural choices with multiple viable approaches
- API surfaces downstream consumers will depend on
- Decisions that are hard to reverse after deployment

## When It Doesn't

- Mechanical implementation where the pattern is established
- Bug fixes or refactors with a clear target state
- Constraints that dictate a single viable approach
