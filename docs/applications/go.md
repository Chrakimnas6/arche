# Go: Principle Applications

How the principles in `docs/principles/` materialize in Go codebases. Read this overlay alongside the principle files when working on Go projects.

## Foundational Thinking

**Concurrency corollary:** Before sharing state between goroutines, ask: "What happens if another actor modifies this concurrently?" If the answer isn't "nothing," isolate. Prefer channels or clear ownership over shared mutable state — a goroutine that owns a value exclusively avoids the entire class of data races.

## Boundary Discipline

### Validation and error handling

- All exported boundary entry points return `(T, error)`. Errors are handled at the boundary, not silently propagated.
- No `panic()` in production code paths — propagate with `return err`. `panic` is for programmer errors (impossible states), not user errors.
- Validate config at parse time (the config boundary), not inside business logic.
- Store raw data at boundaries (`json.RawMessage`, `[]byte`) and parse lazily at use-site to keep the parse failure mode local.

### Code organization

The functional core / imperative shell split in Go: parse and computation are pure `func(In) (Out, error)` with no framework imports; orchestration is thin wiring that calls them and performs the I/O. Keep `net/http`, DB handles, and `context.Context` plumbing in the shell so the core stays unit-testable without spinning up the framework.

## Serialize Shared State Mutations

- **Concurrent goroutines writing to a shared map** crash without `sync.Mutex` or a channel-based ownership pattern. Use `sync.Mutex` for simple critical sections; use channels for ownership transfer.
- **`sync.RWMutex`** for read-heavy workloads where writes are rare; `sync.Mutex` otherwise.
- **`sync/atomic`** for single-word counters; mutexes for anything more complex.
- **Channels as queues:** when one goroutine is the sole writer, others can read without locks.

## Make Operations Idempotent

- **Single-execution init:** wrap one-time setup in `sync.Once` so repeated or concurrent calls run it exactly once.
- **Idempotent migrations:** use a versioned migration tool (golang-migrate, goose) rather than ad-hoc DDL, so re-running a partially-applied set converges instead of erroring.
- **Convergent startup:** on boot, reconcile desired vs. actual — check for an existing PID/lock file, adopt a still-running child, clean a stale socket — so a crashed-and-restarted process lands in the right state regardless of what the previous run left behind.

## Module Depth

A package with 15 exported functions where callers must understand all of them is shallow. A package with 3 exported functions that handle the rest internally is deep. Merge small coordinating packages into a single deep package when the deletion test shows they aren't earning their keep independently.

Idiomatic Go favors small interfaces ("the bigger the interface, the weaker the abstraction" — Pike). Define interfaces at the *consumer* side, not the producer side, so the producer can stay deep and the consumer can take only what it needs.

## Prove It Works

For Go services: run integration tests that hit the real binary over the real network, not just unit tests against handlers. Use `httptest` for HTTP-level tests but verify end-to-end paths in CI.
