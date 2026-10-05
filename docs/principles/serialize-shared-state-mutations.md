# Serialize Shared-State Mutations

**Principle:** When concurrent actors share mutable state, enforce serialization structurally -- lockfiles, sequential phases, exclusive ownership. Instructions and conventions are insufficient for concurrency safety.

## Why

Concurrent writes to shared state (files, branches, APIs, on-chain storage) produce race conditions that are intermittent, hard to reproduce, and expensive to debug. Telling agents or goroutines to "take turns" does not work -- they have no coordination mechanism beyond the instruction itself.

## Pattern

Before allowing any parallel execution:

1. **Identify shared mutable state.** Files both read and write, branches both push to, storage slots multiple transactions touch, queues multiple consumers drain.
2. **If shared state exists, serialize access.** Mutexes, lockfiles, sequential phases, or exclusive ownership.
3. **If serialization is impractical, eliminate the sharing.** Give each actor its own copy (separate files, isolated state directories, per-caller mappings).

The principle generalizes across paradigms: process-level mutexes, contract-level reentrancy guards, deploy-level concurrency groups.
