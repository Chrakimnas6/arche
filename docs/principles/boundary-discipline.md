# Boundary Discipline

**Principle:** Place validation, type narrowing, and error handling at system boundaries. Trust internal code unconditionally. Business logic lives in pure functions; the shell is thin and mechanical.

## Why

Validation scattered throughout a codebase is noisy, redundant, and gives a false sense of safety. Concentrating it at boundaries means each piece of data is validated exactly once -- at the point it enters the system -- and flows freely after that. Similarly, logic tangled with framework wiring can't be tested without the framework and can't be reused across contexts.

## The Pattern

- **At boundaries** (CLI args, config files, external APIs, user input, RPC calls): validate, return `error`, handle defensively.
- **Inside the system**: typed data, `return err` propagation, no re-validation. Trust the types.

In smart contracts, the boundary is the external function signature. Validate all inputs (`require`, custom errors) at the top of external/public functions. Internal functions trust the data they receive.

## Applications

### Validation and Error Handling

- All entry points return `(T, error)` -- errors handled at the boundary, not inside business logic.
- No `panic()` in production Go code -- propagate with `return err`.
- Validate config at parse time (the config boundary), not inside business logic.
- Store raw data at boundaries (`json.RawMessage`) -- parse lazily at use-site.

### Code Organization

Business logic lives in pure functions with no framework dependencies (`(Input) => (Output, error)`). The shell -- CLI routing, HTTP handlers, event dispatching -- is thin and mechanical.

- **Parse functions**: Pure `([]byte) => (State, error)` transforms. No framework dependencies.
- **Computation**: Pure `(Input) => Output` transforms. No side effects.
- **Orchestration**: Thin wiring that calls pure functions and handles I/O.

### Smart Contract Boundary Pattern

- External functions: validate all inputs, check permissions, emit events.
- Internal/private functions: pure computation, trust caller already validated.
- View functions: read-only boundary -- no state validation needed beyond access control.

## The Tests

Before adding a validation check, ask: **"Is this data crossing a system boundary right now?"** If not, the validation is redundant -- trust the types.

Before putting logic in a handler, hook, or framework integration point, ask: **"Can this be a pure function that the shell just calls?"** If yes, extract it.

See also [foundational-thinking](./foundational-thinking.md)
