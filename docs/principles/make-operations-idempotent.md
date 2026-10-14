# Make Operations Idempotent

**Principle:** Design operations so they converge to the correct state regardless of how many times they run or where they start from.

**Why:** crashes, restarts, and retries are normal; an operation whose rerun depends on the partial state it left behind turns every restart into a debugging session.

## Pattern

- **Check before applying.** Migrations check current schema state; deploys check whether the target version is already running and converge from a crashed mid-rollout.
- **Guard initialization.** A state-establishing operation refuses re-execution rather than corrupting state (initializer flags, version checks, atomic swaps).
- **Converge on startup.** Scan for existing processes and state, clean stale artifacts, adopt live resources.

## The Test

Before shipping a state-mutating operation, ask what happens if it runs twice in a row, and if the previous run crashed at each possible point. If any answer is "it depends on what state was left behind," add a reconciliation step.
