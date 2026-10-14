# Observability

**Principle:** Production systems must emit enough signal — structured logs, metrics, traces, events — that humans can answer questions about behavior they didn't anticipate when writing the code. Tests prove what you predicted; observability handles what you didn't.

**Why:** without it, debugging a production failure starts with "add logs and redeploy"; with it, debugging starts with a query against data that already exists.

## Pattern

- **Structured logs at decision boundaries.** Log when the system makes a non-trivial choice (route taken, fallback triggered, retry exhausted), not just on errors. Use structured fields, not concatenated strings.
- **High-cardinality, wide events.** One event with 50 fields beats 50 separate metrics; the unit of observation is the request, not the counter.
- **One trace ID per operation, propagated across every process, service, or contract call.** A request that fans out is still one trace.
- **Emit events for state transitions.** Don't only mutate state; announce mutations, so audits, indexers, and incident reconstruction have a record.
- **Alert on user-visible symptoms (the SLO),** not implementation details: "p99 latency > 2s," not "queue depth > 1000."
- **Budget cardinality, log volume, and sampling** for the fields you'll actually query.

## When It Applies

Any production service; any contract that emits state-altering transactions (indexers and audits need its events); any long-running job, scheduled task, or queue consumer. Not single-shot scripts, or pure computation that returns everything relevant to its synchronous caller.
