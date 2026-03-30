# Serialize Shared-State Mutations

**Principle:** When concurrent actors share mutable state, enforce serialization structurally -- lockfiles, sequential phases, exclusive ownership. Instructions and conventions are insufficient for concurrency safety.

## Why

Concurrent writes to shared state (files, branches, APIs, on-chain storage) produce race conditions that are intermittent, hard to reproduce, and expensive to debug. Telling agents or goroutines to "take turns" does not work -- they have no coordination mechanism beyond the instruction itself.

## Pattern

Before allowing any parallel execution (goroutines, parallel deploys, concurrent contract calls):

1. **Identify shared mutable state.** Files both read and write, branches both push to, storage slots multiple transactions touch.
2. **If shared state exists, serialize access.** Mutexes, lockfiles, sequential phases, or exclusive ownership.
3. **If serialization is impractical, eliminate the sharing.** Give each actor its own copy (separate files, isolated state directories, per-caller storage mappings).

## Examples

- **Go:** Concurrent goroutines writing to a shared map crash without `sync.Mutex` or a channel-based ownership pattern. Use `sync.Mutex` for simple critical sections; use channels for ownership transfer.
- **Smart contracts:** Multiple external calls in a single transaction risk reentrancy. Use reentrancy guards (`nonReentrant` modifier) to serialize state mutations. Check-effects-interactions pattern: update state before making external calls.
- **Deploys / CI:** Parallel deploy scripts targeting the same environment cause race conditions. Serialize with a deploy lock (database row, lockfile, or CI concurrency group).

## Relationship to Other Principles

[Make operations idempotent](./make-operations-idempotent.md) makes reruns safe; this principle prevents concurrent runs. They are complementary, not redundant.

[Encode lessons in structure](./encode-lessons-in-structure.md) is the meta-principle -- this is what to encode when the lesson is about concurrency.
