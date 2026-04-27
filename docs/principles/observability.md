# Observability

**Principle:** Production systems must emit enough signal — structured logs, metrics, traces, events — that humans can answer questions about behavior they didn't anticipate when writing the code. Tests prove what you predicted; observability handles what you didn't.

## Why

Code that runs only in environments you can step through is a different beast from code that runs in production. Production fails in ways the author did not foresee. Without observability, debugging starts with "add logs and re-deploy" — minutes when the system is down. With observability, debugging starts with a query against existing data.

## The Pattern

- **Structured logs at decision boundaries.** Log when the system makes a non-trivial choice (route taken, fallback triggered, retry exhausted), not just on errors. Use structured fields (key=value), not concatenated strings.
- **High-cardinality, wide events.** A single event with 50 fields beats 50 separate metrics. The unit of observation is the *request*, not the *counter*.
- **Trace identifiers propagated across boundaries.** Any operation that crosses a process, service, or contract call must carry a correlation ID. Without it, debugging multi-component failures is guessing.
- **Emit events for state transitions.** State changes are the substrate of audit trails, indexer correctness, and post-incident reconstruction. Don't only mutate state — *announce* mutations.
- **Alert on user-visible symptoms, not implementation details.** "Latency p99 > 2s" is a symptom; "queue depth > 1000" is an implementation detail that may or may not matter.

## Heuristics

- **If it isn't logged, it didn't happen.** Memory of a process is a candle; observability is a record.
- **The right cardinality is high.** Per-user, per-request, per-trace fields produce queries; per-bucket counters produce dashboards. Prefer the former.
- **One trace ID per operation, propagated everywhere.** A request that fans out should still be one trace.
- **Alert on the SLO, not the metric.** Pages should fire when users are affected, not when an internal threshold trips.
- **Observability budgets are real.** Cardinality, log volume, and trace sampling have costs. Design for the highest-cardinality fields you'll actually query.

## When It Applies

- Any service that runs in production
- Any contract that emits state-altering transactions (events are required for indexers and audits)
- Any long-running job, scheduled task, or queue consumer

## When It Doesn't

- Single-shot scripts
- Pure computation called only synchronously and returning all relevant info to the caller

## Relationship to Other Principles

[Prove it works](./prove-it-works.md) is verification at task completion; observability is verification continuously, in production, by the operator. The two cover different time horizons.

[Fix root causes](./fix-root-causes.md) requires evidence to trace causes. Observability provides that evidence ahead of time. Without it, "instrument when stuck" means starting over.

Language-specific applications live in [docs/applications/](../applications/).

## Citations

Majors, Fong-Jones, Miranda, *Observability Engineering* (O'Reilly, 2022) — high-cardinality structured events as the foundation of modern observability. Beyer, Jones, Petoff, Murphy, *Site Reliability Engineering* (O'Reilly, 2016) and *The Site Reliability Workbook* (O'Reilly, 2018) — SLI/SLO/error-budget framework; alert on user-visible symptoms. Brendan Gregg, *Systems Performance* (2nd ed., Pearson, 2020) — the USE method (utilization, saturation, errors) for resource-level observability. RED (rate, errors, duration) is Tom Wilkie's complementary service-level framing.
