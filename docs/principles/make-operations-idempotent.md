# Make Operations Idempotent

**Principle:** Design operations so they converge to the correct state regardless of how many times they run or where they start from. Every state-mutating operation should answer: "What happens if this runs twice? What happens if the previous run crashed halfway?"

## Why

CLI commands, lifecycle operations, and scheduling loops run in environments where crashes, restarts, and retries are normal. If an operation leaves partial state that causes a different outcome on re-execution, every restart becomes a debugging session.

## The Pattern

- **Idempotent database migrations:** Use `CREATE TABLE IF NOT EXISTS` / `CREATE INDEX IF NOT EXISTS`. Check current schema state before applying changes so re-running the migration is always safe.
- **Idempotent deploy scripts:** Check whether the desired version is already running before deploying. If a deploy crashed mid-rollout, re-running should detect partial state and converge to the target.
- **Contract initialization guards:** Use the initializer pattern (`initialized` boolean + require check) so that `initialize()` cannot corrupt state if called again after deployment. In upgradeable proxies, use OpenZeppelin's `initializer` modifier to enforce single execution per version.
- **Convergent startup:** Scan for existing processes/state, clean stale artifacts, adopt live resources -- converging to the correct state regardless of what the previous run left behind.

## The Test

Before shipping a state-mutating operation, ask:
1. What happens if this runs twice in a row?
2. What happens if the previous run crashed at every possible point?
3. Does re-execution converge to the same end state?

If any answer is "it depends on what state was left behind," the operation needs a reconciliation step.

## Relationship to Other Principles

- Extends [fix root causes](./fix-root-causes.md) by preventing a class of root causes (partial completion) at design time
- Complements [fix root causes](./fix-root-causes.md) by making state self-correcting rather than requiring debugging
- Distinct from [encode lessons in structure](./encode-lessons-in-structure.md) (which is about how to encode rules, not operation design)
