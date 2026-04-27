# Boundary Discipline

**Principle:** Place validation, type narrowing, and error handling at system boundaries. Trust internal code unconditionally. Business logic lives in pure functions; the shell is thin and mechanical.

## Why

Validation scattered throughout a codebase is noisy, redundant, and gives a false sense of safety. Concentrating it at boundaries means each piece of data is validated exactly once -- at the point it enters the system -- and flows freely after that. Similarly, logic tangled with framework wiring can't be tested without the framework and can't be reused across contexts.

## The Pattern

- **At boundaries** (CLI args, config files, external APIs, user input, RPC calls): validate, surface errors, handle defensively.
- **Inside the system:** typed data, error propagation as values, no re-validation. Trust the types.

## Applications

### Validation and error handling

- All boundary entry points return values + errors. Errors are handled at the boundary, never silently swallowed and never raised as global aborts in production paths.
- Validate config at parse time (the config boundary), not inside business logic.
- Store raw payloads at boundaries; parse lazily at use-site to keep the parse failure mode local.

### Code organization

Business logic lives in pure functions with no framework dependencies. The shell — CLI routing, HTTP handlers, event dispatching — is thin and mechanical.

- **Parse functions:** pure transforms from raw input to structured state. No framework dependencies.
- **Computation:** pure transforms from input to output. No side effects.
- **Orchestration:** thin wiring that calls pure functions and handles I/O.

Language-specific applications (Go error patterns, smart-contract external/internal split) live in [docs/applications/](../applications/).

## The Tests

Before adding a validation check, ask: **"Is this data crossing a system boundary right now?"** If not, the validation is redundant — trust the types.

Before putting logic in a handler, hook, or framework integration point, ask: **"Can this be a pure function that the shell just calls?"** If yes, extract it.

See also [foundational-thinking](./foundational-thinking.md), [threat-modeling](./threat-modeling.md).

## Citations

Postel's Law (RFC 793, 1981) — "be conservative in what you do, be liberal in what you accept from others." Hunt & Thomas, *The Pragmatic Programmer* (1999) — design by contract, assertive programming. Eric Evans, *Domain-Driven Design* (2003) — bounded contexts and anti-corruption layers at integration boundaries.
