# Foundational Thinking

**Principle:** Structural decisions (data models, phase ordering, infrastructure) optimize for option value. Code-level decisions (helpers, abstractions, patterns) optimize for simplicity. Over-engineering closes doors (one-use helpers, flags for hypothetical needs, layers "in case we swap X"); the data structure that matches real access patterns opens them, even when a simpler one works for now.

## Data Structures First

- **Settle the core types before writing logic.** Trace every access pattern (reads, writes, iterations, lookups, serialization) through a proposed structure and pick the one that fits the dominant pattern. A structure change late is a rewrite; early it is a one-line diff.
- **Name the organizing structure the code is missing.** Choose the model that makes illegal states unrepresentable: a state machine over scattered booleans, a table or registry over spread-out branching, a typed model over repeated shape assumptions. It must *delete* branches and invalid states, not relocate them; keep boring explicit code when the shape is already clear and local. Modules named for execution phases (load, validate, transform, save) that repeat the same domain rules signal the wrong structure: group code by the knowledge it protects.
- **Types are constructions, not restrictions.** Build the type from the values you want (a non-empty list is a head plus a rest; a time range is a start plus a duration) rather than carving a looser type down with runtime checks. A runtime assertion, nil check, or "should never happen" branch marks where a type is too weak: push that check into the type, then stop. Precision beyond keeping operations total buys no safety.
- **DRY the types and data models, not the code.** Three similar lines beat a premature abstraction.
- **No placeholder source files.** Create a file only when it has real code.

## Scaffold First

- **If every later phase benefits from it, it is Phase 1:** CI, linting, test infra, shared types, project config. Subtraction ([subtract-before-you-add](./subtract-before-you-add.md)) comes before scaffolding.
- **Order the stack so the sequence proves itself to a reviewer:** the failing test before the fix, the subtraction before the reshape, the baseline capture before the treatment. Each commit stands alone; the sequence reads as an argument.
- **Each increment lands a coherent abstraction or deepens an existing one.** Don't spread a new capability across callers as special-case coordination.
