# Module Depth

**Principle:** Prefer deep modules -- small interfaces hiding large implementations. Module depth produces leverage for callers and locality for maintainers.

## Vocabulary

Use these terms consistently when discussing architecture. Don't substitute "component," "service," "API," or "boundary."

- **Module** -- anything with an interface and an implementation. Scale-agnostic: a function, package, contract, or tier-spanning slice.
- **Interface** -- everything a caller must know to use the module correctly. Includes the type signature, but also invariants, ordering constraints, error modes, and configuration. Not just the Go function signature or Solidity external function -- the full contract with the caller.
- **Depth** -- leverage at the interface. A module is deep when a large amount of behavior sits behind a small interface. A module is shallow when the interface is nearly as complex as the implementation.
- **Seam** -- a place where you can alter behavior without editing in that place. Where a module's interface lives. Distinct from "boundary" (overloaded with DDD bounded contexts). From Michael Feathers, "Working Effectively with Legacy Code."
- **Adapter** -- a concrete thing that satisfies an interface at a seam. Describes role (what slot it fills), not substance (what's inside).
- **Leverage** -- what callers get from depth. More capability per unit of interface they must learn.
- **Locality** -- what maintainers get from depth. Change, bugs, knowledge, and verification concentrate in one place. Fix once, fixed everywhere.

## Key Heuristics

**The deletion test.** Imagine deleting the module. If complexity vanishes, the module wasn't hiding anything -- it was a pass-through. If complexity reappears across N callers, the module was earning its keep.

**The interface is the test surface.** Callers and tests cross the same seam. If you need to test past the interface, the module is probably the wrong shape.

**One adapter means a hypothetical seam. Two adapters means a real one.** Don't introduce a seam unless something actually varies across it. A single-adapter seam is just indirection.

**Depth is a property of the interface, not the implementation.** A deep module can be internally composed of small, swappable parts -- they just aren't part of the interface. Internal seams (private, used by tests) are fine; exposing them through the module's interface is not.

## Deepening Safely

When merging shallow modules into a deeper one, classify dependencies to determine the testing strategy:

1. **In-process** -- Pure computation, in-memory state, no I/O. Always deepenable. Merge and test through the new interface directly.
2. **Local-substitutable** -- Dependencies with local test stand-ins (e.g., in-memory filesystem, embedded DB). Test with the stand-in; the seam is internal.
3. **Remote but owned** -- Your own services across a network boundary. Define a port at the seam, inject the transport as an adapter. Tests use an in-memory adapter; production uses the real one.
4. **True external** -- Third-party services you don't control. The deep module takes the dependency as an injected port; tests provide a mock adapter.

### Testing: replace, don't layer

- Old unit tests on shallow modules become waste once tests at the deepened module's interface exist -- delete them.
- Write new tests at the deepened interface. The interface is the test surface.
- Tests assert on observable outcomes through the interface, not internal state.
- Tests should survive internal refactors. If a test breaks when the implementation changes but the interface doesn't, it's testing past the seam.

## Applications

### Go

A package with 15 exported functions where callers must understand all of them to use the package correctly is shallow. A package with 3 exported functions that handle the rest internally is deep. Merge small coordinating packages into a single deep package when the deletion test shows they aren't earning their keep independently.

### Smart Contracts

External functions are the interface; internal functions are the implementation. A contract that exposes many small external functions each doing one storage write is shallow. A contract that exposes a few external functions orchestrating complex state transitions behind a clean interface is deep. The seam is the contract boundary; the adapter is the deployment (e.g., proxy vs direct).

## Relationship to Other Principles

[Boundary discipline](./boundary-discipline.md) governs *validation* at system boundaries. Module depth governs *interface design* -- how much behavior to hide behind each interface. They compose: validate at boundaries, then trust the deep module internally.

[Exhaust the design space](./exhaust-the-design-space.md) applies when choosing *which* deep interface to build. Explore multiple interface designs before committing.

See also [foundational-thinking](./foundational-thinking.md) -- data structures and interfaces first, optimize for option value.
