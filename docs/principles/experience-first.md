# Experience First

**Principle:** The experience is the target; implementation choices are subordinate. When implementation convenience and the experience the system delivers conflict, choose the experience.

"Experience" means whoever uses what you build: end users for products, integrators for libraries, operators for tools, callers for contracts. They live with your interface decisions; you live with your implementation decisions.

## Pattern

- **Prototype the experience before committing the implementation.** A throwaway sketch a user or integrator can react to is cheaper than a production rewrite.
- **Optimize the surface callers see, even at internal cost.** A more complex implementation behind a clean interface is almost always the right trade.
- **Error messages are part of the interface.** Say which field failed, why, and what would be valid. Ask what the caller would see when this fails; "they'll figure it out" means the interface isn't done.

## Integrator Heuristics

For libraries, SDKs, CLIs, contracts, and anything called by external code:

- **Predictable signatures.** Same operation, same shape: if `get(key)` returns `(value, error)`, `getAll(query)` returns `(values, error)`.
- **No surprise in state transitions.** If `start()` does anything besides start, rename it or document it loudly.
- **Docs match behavior.** Change the docs in the same commit as the behavior; stale docs teach a mental model that breaks at the worst time.

## When This Doesn't Apply

- Internal helpers called only within the same module
- One-off scripts where you are the only user
- A clear constraint (performance, gas cost, security) dominates
