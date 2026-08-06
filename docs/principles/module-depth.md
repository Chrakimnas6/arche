# Module Depth

**Principle:** Prefer deep modules -- small interfaces hiding large implementations. Module depth produces leverage for callers and locality for maintainers.

## Vocabulary

Use these terms consistently when discussing architecture. Don't substitute "component," "service," "API," or "boundary."

- **Module** -- anything with an interface and an implementation. Scale-agnostic: a function, package, contract, or tier-spanning slice.
- **Interface** -- everything a caller must know to use the module correctly. Includes the type signature, but also invariants, ordering constraints, error modes, and configuration. Not just the function signature -- the full contract with the caller.
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

**Reader load has two axes: layers-to-trace and state-to-hold.** When judging whether code is hard to follow, count the abstraction layers a reader must cross to answer a question, and the mutable state they must hold in their head while crossing them -- not the number of files. Collapse wrappers with a single caller; shrink the scope of mutable state. (Internal structure spread across files is fine when the interface stays small -- that's depth working.)

## Red Flags

Screen every interface — proposed or existing — against these. Each is a reason to revise the shape.

- **Shallow module.** The interface is nearly as complex as what it hides. Signs: callers coordinate several calls to complete one operation; public options expose internal stages or implementation choices; learning the interface doesn't spare the caller from learning the implementation.
- **Information leakage.** One internal decision — a representation, policy, or protocol detail — appears in more than one module, so changing it requires coordinated edits. Re-exporting transport, storage, or framework types through a public surface is leakage; parse external data into domain types behind the interface (see [boundary-discipline](./boundary-discipline.md)).
- **Temporal decomposition.** Modules organized by execution order (load, validate, transform, save) instead of the knowledge they own, repeating one representation and its invariants across several boundaries. Group code by domain knowledge and ownership; methods that run at different times can share a module when they protect the same decisions. Execution order is not ownership.
- **Pass-through method.** Forwards the same arguments to another method with the same shape — a layer that hides nothing. Remove it or move the responsibility to the module that can complete the operation; keep a forwarding boundary only when it adds policy, adaptation, or a distinct abstraction. The deletion test above catches these.

Don't confuse a deep module with a deep call chain: a chain scatters understanding across layers, a deep module concentrates capability behind one interface. A rich interface can keep call chains short.

## Deepening Safely

When merging shallow modules into a deeper one, classify dependencies to determine the testing strategy:

1. **In-process** -- Pure computation, in-memory state, no I/O. Always deepenable. Merge and test through the new interface directly.
2. **Local-substitutable** -- Dependencies with local test stand-ins (e.g., in-memory filesystem, embedded DB). Test with the stand-in; the seam is internal.
3. **Remote but owned** -- Your own services across a network boundary. Define a port at the seam, inject the transport as an adapter. Tests use an in-memory adapter; production uses the real one.
4. **True external** -- Third-party services you don't control. The deep module takes the dependency as an injected port; tests provide a mock adapter.

### Testing: replace, don't layer

- Don't write *new* tests below the deepened seam — the interface is the test surface.
- Existing internal tests that duplicate interface-level coverage can be deleted; keep ones that retain unique diagnostic or regression value.
- Tests assert on observable outcomes through the interface, not internal state.
- Tests should survive internal refactors. If a test breaks when the implementation changes but the interface doesn't, it's testing past the seam.

## Relationship to Other Principles

[Boundary discipline](./boundary-discipline.md) governs *validation* at system boundaries. Module depth governs *interface design* -- how much behavior to hide behind each interface. They compose: validate at boundaries, then trust the deep module internally.

[Exhaust the design space](./exhaust-the-design-space.md) applies when choosing *which* deep interface to build. Explore multiple interface designs before committing.

See also [foundational-thinking](./foundational-thinking.md) -- data structures and interfaces first, optimize for option value. Language-specific applications live in [docs/applications/](../applications/).

## Citations

Ousterhout, *A Philosophy of Software Design* (2nd ed., 2021) — the source of "deep modules" and the depth/shallow framing. Feathers, *Working Effectively with Legacy Code* (Prentice Hall, 2004) — seam vocabulary. Brooks, *The Mythical Man-Month* (1975) — "conceptual integrity is the most important consideration in system design."
