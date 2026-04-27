# Serialize Shared-State Mutations

**Principle:** When concurrent actors share mutable state, enforce serialization structurally -- lockfiles, sequential phases, exclusive ownership. Instructions and conventions are insufficient for concurrency safety.

## Why

Concurrent writes to shared state (files, branches, APIs, on-chain storage) produce race conditions that are intermittent, hard to reproduce, and expensive to debug. Telling agents or goroutines to "take turns" does not work -- they have no coordination mechanism beyond the instruction itself.

## Pattern

Before allowing any parallel execution:

1. **Identify shared mutable state.** Files both read and write, branches both push to, storage slots multiple transactions touch, queues multiple consumers drain.
2. **If shared state exists, serialize access.** Mutexes, lockfiles, sequential phases, or exclusive ownership.
3. **If serialization is impractical, eliminate the sharing.** Give each actor its own copy (separate files, isolated state directories, per-caller mappings).

The principle generalizes across paradigms: process-level mutexes, contract-level reentrancy guards, deploy-level concurrency groups. Language-specific applications (Go mutex/channel patterns, smart-contract reentrancy guards, CI deploy locks) live in [docs/applications/](../applications/).

## Relationship to Other Principles

[Make operations idempotent](./make-operations-idempotent.md) makes reruns safe; this principle prevents concurrent runs. They are complementary, not redundant.

[Encode lessons in structure](./encode-lessons-in-structure.md) is the meta-principle -- this is what to encode when the lesson is about concurrency.

## Citations

Lamport, "Time, Clocks, and the Ordering of Events in a Distributed System" (CACM 21:7, 1978) — ordering and causality in concurrent systems. Hoare, "Communicating Sequential Processes" (CACM, 1978; book Prentice Hall, 1985) — channels-and-processes model that informs Go's concurrency primitives. Kleppmann, *Designing Data-Intensive Applications* (2017) — serialization, locks, and transactional isolation in practice.
