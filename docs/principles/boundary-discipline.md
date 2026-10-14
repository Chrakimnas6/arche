# Boundary Discipline

**Principle:** Place validation, type narrowing, and error handling at system boundaries. Trust internal code unconditionally. Business logic lives in pure functions; the shell is thin and mechanical.

**Why:** validating each piece of data once, where it enters, lets it flow freely afterward; logic tangled with framework wiring can't be tested or reused without the framework.

## Pattern

- **At boundaries** (CLI args, config, external APIs, user input, RPC): validate, surface errors, handle defensively. Return errors as values; never swallow them or abort globally on production paths.
- **Inside the system:** typed data, errors propagated as values, no re-validation.
- **Across the boundary:** expose domain concepts, not the boundary's private representation. Do not re-export transport, storage, framework, or wire types.
- **Parse into a named domain type at the boundary.** The generic representation (raw map, string-keyed dictionary, untyped blob) stops at that parse and appears in no internal signature. Storing a raw payload and parsing lazily spreads the parse failure to every use site and makes internal code distrust its inputs.

## The Tests

- Before adding a validation check: **"Is this data crossing a system boundary right now?"** If not, trust the types.
- Before putting logic in a handler, hook, or framework integration point: **"Can this be a pure function the shell just calls?"** If yes, extract it.
