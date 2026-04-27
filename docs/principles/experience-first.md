# Experience First

**Principle:** The experience is the target. Implementation choices are subordinate. When a tradeoff exists between implementation convenience and the experience the system delivers, choose the experience.

## Why

"Experience" here means the experience of whoever uses what you build — end users for products, integrators for libraries, operators for tools, callers for contracts. They live with the consequences of your interface decisions; you live with the consequences of your implementation decisions. The asymmetry favors investing in the former.

This is not a principle about polish or aesthetics. It's a principle about *target*: it says foundations exist to serve experience, not the other way around. [Foundational thinking](./foundational-thinking.md) governs the *sequence* of work; this governs the *target*.

## The Pattern

- **Prototype the experience before committing the implementation.** A throwaway sketch that an integrator/user can react to is cheaper than a production rewrite. This is distinct from [exhaust-the-design-space](./exhaust-the-design-space.md), which prototypes *implementation alternatives*; this prototypes the *interface that will be lived with*.
- **Optimize the surface that callers see, even at internal cost.** A slightly more complex implementation behind a clean interface is almost always the right tradeoff. (See [module-depth](./module-depth.md): deep modules earn their keep here.)
- **Error messages are part of the interface.** A function that returns "invalid input" without saying which field, why, or what would be valid has a worse interface than the same function with no validation at all — at least the latter is honest about what it does.

## Integrator-Experience Heuristics

For libraries, SDKs, CLIs, contracts, and other things called by external code:

- **Predictable signatures.** Same operation, same shape. If `get(key)` returns `(value, error)`, then `getAll(query)` should also return `(values, error)` — not a new shape.
- **Minimal surprise in state transitions.** If calling `start()` does anything other than start, document it loudly or rename it.
- **Documentation that matches actual behavior.** Docs that lag the code are worse than no docs — they teach a mental model that breaks at the worst time. When you change behavior, change the docs in the same commit.
- **Failure modes you'd want to debug.** When this fails, what would the caller see? If the answer is "they'll figure it out," the interface isn't done.

## When This Doesn't Apply

- Internal helpers called only by code in the same module
- One-off scripts where you are the only user
- Cases where a clear constraint (performance, gas cost, security) dominates

## Relationship to Other Principles

[Foundational thinking](./foundational-thinking.md) governs the *sequence* of work (data structures first). This governs the *target* (the data structures exist to serve the experience).

[Module depth](./module-depth.md) gives the mechanism: deep modules let you optimize the experience without paying the implementation tax at every call site.

[Subtract before you add](./subtract-before-you-add.md) overlaps on "ship less, polish more" — this principle adds the *target* dimension that "less" alone doesn't capture.

## Citations

Norman, *The Design of Everyday Things* (1988, revised 2013) — affordances and signifiers; design centered on the user's mental model. Krug, *Don't Make Me Think* (New Riders, 2000) — usability as the absence of friction at the interface. Hickey, "Simple Made Easy" (Strange Loop, 2011) — predictability and decomplecting. Kernighan & Pike, *The Practice of Programming* (Addison-Wesley, 1999) — interface ergonomics for libraries and tools.
