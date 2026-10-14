# Serialize Shared-State Mutations

**Principle:** When concurrent actors share mutable state, enforce serialization structurally -- lockfiles, sequential phases, exclusive ownership. Instructions and conventions are insufficient for concurrency safety.

**Why:** telling agents or goroutines to "take turns" fails, because the instruction is their only coordination mechanism, and the resulting races are intermittent and hard to reproduce.

## Pattern

Before allowing any parallel execution:

1. **Identify shared mutable state:** files both read and write, branches both push to, storage slots several transactions touch, queues several consumers drain.
2. **Serialize access to it:** mutexes, lockfiles, sequential phases, exclusive ownership.
3. **If serialization is impractical, eliminate the sharing:** give each actor its own copy (separate files, isolated state directories, per-caller mappings).
