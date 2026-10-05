# Prove It Works

**Principle:** Every task output must be verified by checking the real thing directly -- not by inferring from proxies, self-reports, or "it compiles."

**Why:** acting on a wrong inference costs far more than checking the source.

## Pattern

- **Check the real thing, not a proxy.** Process liveness from the PID or process table, not a file mtime or cached status; the actual value, not a cached or derived representation.
- **When verification fails, suspect the observation method** before suspecting the system.
- **An exit code is not evidence the work ran.** A test run that selected nothing passes (`go test` prints `[no tests to run]` and exits 0). Confirm the run's count names the tests you meant.
- **Claimed limitations need evidence.** "The API can't do this", "X requires a credential", "that's impossible on this platform" are material claims. State one only with the verbatim error, the documented statement, or a live probe in hand; pattern-matching a failure to a familiar story is not evidence. When a cheap probe settles it, run it before declaring a step blocked or asking for help.
- **Explain measured numbers.** A run that went wrong still prints a plausible number: failed requests, cached or skipped work, an untuned side, and noise all look fine. Before reporting or acting on a measurement, name what limits it ("why isn't it twice as good?") from a profile or counters, not from reading code, and rule out those alternatives with evidence. Keep the run count, spread, and limiter beside the number. The `hillclimb` skill applies this per attempt.
- **Sweeps and migrations: verify per unit, not per batch.** Known-good state, one change, run the check, proceed. A break caught at the unit that caused it is cheap to localize; one caught after the batch is buried under everything built on top.
- **Delegation: trust artifacts, not self-reports.** Inspect the output (`git diff --stat`, file contents, runtime behavior), never the delegate's summary. Delegates report what they intended; scope violations and silent failures show only in the artifact.
