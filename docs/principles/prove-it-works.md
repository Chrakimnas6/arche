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

### Code / Features
1. Build it (necessary but not sufficient)
2. Run it and exercise the actual feature path
3. Check the full chain: does data flow from input to output?
4. For integrations (IPC, sockets, RPC), test the full communication path end-to-end

### Scripts / Tools
1. Run scripts with real inputs and verify output
2. Test error paths: bad input, missing files, timeouts

### General
- If you can run it, run it
- Prefer automated verification over manual inspection

### Delegation: trust artifacts, not self-reports

When verifying delegated work, inspect the actual output artifact (`git diff --stat`, file contents, runtime behavior) -- never the delegate's summary of what they claim to have done. Agents report what they intended, not always what happened. Scope violations and silent failures are invisible in self-reports but obvious in artifacts.

Language-specific applications (testnet deployment for contracts, integration test patterns in Go) live in [docs/applications/](../applications/).

## Relationship to Other Principles

[Fix root causes](./fix-root-causes.md) extends this to debugging — check the real cause, not the proxied symptom.

[Observability](./observability.md) extends this to production — verify continuously through emitted signal, not just at task completion.

## Citations

Dijkstra, "The Humble Programmer" (Turing Award lecture, EWD 340, 1972) — "Program testing can be used to show the presence of bugs, but never to show their absence." Beck, *Test-Driven Development by Example* (Addison-Wesley, 2002) — automated tests as proof of behavior. Goodhart's Law (Goodhart, 1975; popularized by Strathern, 1997) — when a measure becomes a target, it ceases to be a good measure. Verify the real thing, not the proxy.
