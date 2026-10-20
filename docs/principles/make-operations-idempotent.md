# Make Operations Idempotent

**Principle:** Design operations so they converge to the correct state regardless of how many times they run or where they start from.

**Why:** crashes, restarts, and retries are normal; an operation whose rerun depends on the partial state it left behind turns every restart into a debugging session.

## Pattern

- **Derive each step from the state that exists, not from what the previous run meant to do.** Read current state, compare it to the goal, apply only the difference; a repeat finds nothing left to do. Migrations check current schema state; deploys check whether the target version is already running and converge from a crashed mid-rollout.
- **Guard initialization.** A state-establishing operation refuses re-execution rather than corrupting state (initializer flags, version checks, atomic swaps).
- **Leave nothing the next run can't judge.** A lock, temp file, half-written record, or claimed job must be recognizable as stale by evidence that holds wherever the previous run stopped, not only in the common case: write to a temp path and rename into place, compare artifacts by content rather than creation order. On startup, scan for existing processes and state, clean what is stale, adopt what is live.

## The Test

Before shipping a state-mutating operation, ask what happens if it runs twice in a row, and if the previous run crashed at each possible point. If any answer is "it depends on what state was left behind," add a reconciliation step.
