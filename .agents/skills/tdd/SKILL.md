---
name: tdd
description: Test-driven development with red-green-refactor loop. Use when building a feature or fixing a bug test-first, or when the user mentions TDD or red-green-refactor.
---

# Test-Driven Development (TDD)

## The Iron Law

```
NO PRODUCTION CODE WITHOUT A FAILING TEST FIRST
```

Code written before its test is discarded and reimplemented from the test — not kept as a reference or adapted. That includes code that seems too simple to test, code you already checked by hand, and exploratory spikes.

## Philosophy

**Core principle:** Tests should verify behavior through public interfaces, not implementation details. Code can change entirely; tests shouldn't.

## Anti-Pattern: Horizontal Slices

**DO NOT write all tests first, then all implementation.** This is "horizontal slicing" - treating RED as "write all tests" and GREEN as "write all code."

This produces **crap tests**:

- Tests written in bulk test _imagined_ behavior, not _actual_ behavior
- You end up testing the _shape_ of things (data structures, function signatures) rather than user-facing behavior
- Tests become insensitive to real changes - they pass when behavior breaks, fail when behavior is fine
- You outrun your headlights, committing to test structure before understanding the implementation

**Correct approach**: Vertical slices via tracer bullets. One test -> one implementation -> repeat. Each test responds to what you learned from the previous cycle. Because you just wrote the code, you know exactly what behavior matters and how to verify it.

```
WRONG (horizontal):
  RED:   test1, test2, test3, test4, test5
  GREEN: impl1, impl2, impl3, impl4, impl5

RIGHT (vertical):
  RED->GREEN: test1->impl1
  RED->GREEN: test2->impl2
  RED->GREEN: test3->impl3
  ...
```

## Workflow

### 1. Planning

**Align with existing domain language.** Use the project's domain glossary and naming conventions so test names and interface vocabulary match the project's language; respect any design docs or ADRs (e.g. in `docs/design/`) governing the area you're touching. Consistent terms across tests and code make tests read as specifications.

Before writing code, identify the **seams** — the public boundaries tests observe — and list the requested behaviors to test, prioritizing critical paths and complex logic.

- **Established scope:** A clear user request and existing interfaces, or a plan brief's Data structures and Verification sections, supply the seams and behaviors. Proceed without another approval round.
- **Unresolved direction:** If the request and code leave materially different interface or behavior choices open, ask only about those choices before writing dependent tests. When the interface design is in question, consult `docs/principles/module-depth.md`.

Test observable behavior through those seams, not internal implementation steps. Design new interfaces for testability within the agreed scope; do not invent additional behavior to test.

### 2. Tracer Bullet

Write ONE test that confirms ONE thing about the system:

```
RED:   Write test for first behavior -> test fails
GREEN: Write minimal code to pass -> test passes
```

This is your tracer bullet - proves the path works end-to-end.

### 3. Incremental Loop

For each remaining behavior:

```
RED:   Write next test -> fails
GREEN: Minimal code to pass -> passes
```

Rules:

- One test at a time
- Only enough code to pass current test
- Don't anticipate future tests
- Keep tests focused on observable behavior

### 4. Refactor

After all tests pass, look for refactor candidates:

- [ ] Extract duplication
- [ ] Deepen modules — see `docs/principles/module-depth.md`
- [ ] Consider what new code reveals about existing code
- [ ] Run tests after each refactor step

**Never refactor while RED.** Get to GREEN first.

## References

- See [testing-anti-patterns.md](references/testing-anti-patterns.md) for how to write tests that catch real breaks — name the break, avoid change detectors, the mutation check — and common pitfalls when adding mocks or test utilities
- See [mocking.md](references/mocking.md) for guidelines on when and how to mock
