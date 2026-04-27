# Smart Contracts: Principle Applications

How the principles in `docs/principles/` materialize in smart contract codebases. Read this overlay alongside the principle files when working on contracts.

## Foundational Thinking

**Storage layout decisions are permanent after deployment.** Choosing the right mapping/struct shape up front avoids costly migrations or proxy rewrites. A storage layout change late in the project is not a refactor — it's a redeployment with migration.

**Concurrency corollary:** consider reentrancy as the concurrency equivalent. The `nonReentrant` modifier and check-effects-interactions pattern are how you isolate.

## Redesign From First Principles

You cannot patch a deployed contract the way you patch a service. If a new requirement surfaces, redesign the contract interface as if that requirement existed from the start, rather than layering adapter logic on top. The cost of redeployment + state migration dominates the cost of redesign.

## Subtract Before You Add

Subtraction is even more valuable for contracts: every line of deployed code is attack surface. Remove unused functions, dead modifiers, and speculative extension points before shipping. Gas cost is proportional to complexity; less code means cheaper execution.

## Outcome-Oriented Execution

When migrating from v1 to v2 of a contract, design the v2 end state cleanly rather than contorting v1 to stay backward-compatible during the transition. Use migration scripts that converge on the target state and verify invariants at the end.

## Boundary Discipline

The boundary is the external function signature.

- **External functions:** validate all inputs (`require`, custom errors), check permissions, emit events at the top.
- **Internal/private functions:** trust the data they receive. Pure computation. No re-validation.
- **View functions:** read-only boundary — no state validation needed beyond access control.

## Make Operations Idempotent

**Contract initialization guards:** Use the initializer pattern (`initialized` boolean + require check) so that `initialize()` cannot corrupt state if called again after deployment. In upgradeable proxies, use OpenZeppelin's `initializer` modifier to enforce single execution per version.

## Serialize Shared State Mutations

Multiple external calls in a single transaction risk reentrancy. Use reentrancy guards (`nonReentrant` modifier) to serialize state mutations. Apply the **check-effects-interactions** pattern: validate inputs, update state, *then* make external calls. State modifications must complete before any external call has the chance to recursively re-enter.

## Module Depth

External functions are the interface; internal functions are the implementation. A contract that exposes many small external functions each doing one storage write is shallow. A contract that exposes a few external functions orchestrating complex state transitions behind a clean interface is deep. The seam is the contract boundary; the adapter is the deployment (e.g., proxy vs. direct).

## Prove It Works

**Deploy to a local testnet and call the function.** Reading the ABI is not verification. For upgrades, verify storage layout compatibility by deploying both old and new contracts on a fork and asserting state-slot equivalence.

## Stop on Ambiguity

Smart contract storage layout decisions where the wrong choice is permanent. If two layouts are plausible and the implications differ post-deployment, stop and present the options.
