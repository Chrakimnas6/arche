# Prove It Works

**Principle:** Every task output must be verified by checking the real thing directly -- not by inferring from proxies, self-reports, or "it compiles."

## Why

Unverified work has unknown correctness. Indirect verification (file mtimes, output freshness, cached screenshots) feels cheaper than direct observation, but acting on a wrong inference costs far more than checking the source.

## Pattern

After completing any task, ask: **"How do I prove this actually works?"**

### Check the real thing, not a proxy
- **Check process liveness directly** (PID, process table), not indirectly (file mtime, cached status).
- **Read the actual value**, not a cached or derived representation.
- **When verification fails, suspect the observation method** before suspecting the system.

Build it, run it end-to-end against real inputs -- including error paths and integration boundaries -- and prefer automated checks over manual inspection.

### Claimed limitations need evidence

Verification applies to blockers, not just successes. A claimed limitation or requirement -- "the API can't do this", "X requires a credential", "that's impossible on this platform" -- is a material claim. State one only with the verbatim error, the documented statement, or a live probe in hand; pattern-matching a failure to a familiar story is not evidence. When a cheap probe settles the question, run it before declaring a step blocked or asking for help.

### Sweeps and migrations: verify per unit, not per batch
In a run of similar edits, verify each change before starting the next -- known-good state, one change, run the check, proceed. Never batch the edits and verify once at the end: a break caught at the unit that caused it is cheap to localize; a break caught after the batch is buried under everything built on top of it.

### Delegation: trust artifacts, not self-reports

When verifying delegated work, inspect the actual output artifact (`git diff --stat`, file contents, runtime behavior) -- never the delegate's summary of what they claim to have done. Agents report what they intended, not always what happened. Scope violations and silent failures are invisible in self-reports but obvious in artifacts.

Language-specific applications (testnet deployment for contracts, integration test patterns in Go) live in [docs/applications/](../applications/).

## Relationship to Other Principles

[Fix root causes](./fix-root-causes.md) extends this to debugging — check the real cause, not the proxied symptom.

[Observability](./observability.md) extends this to production — verify continuously through emitted signal, not just at task completion.

## Citations

Dijkstra, "Notes on Structured Programming" (EWD 249, 1970) — "Program testing can be used to show the presence of bugs, but never to show their absence." Beck, *Test-Driven Development by Example* (Addison-Wesley, 2002) — automated tests as proof of behavior. Goodhart's Law (Goodhart, 1975; popularized by Strathern, 1997) — when a measure becomes a target, it ceases to be a good measure. Verify the real thing, not the proxy.
