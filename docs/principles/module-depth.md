# Module Depth

**Principle:** Prefer deep modules -- small interfaces hiding large implementations. Module depth produces leverage for callers and locality for maintainers.

## Vocabulary

- **Module:** anything with an interface and an implementation, at any scale: function, package, contract, tier-spanning slice.
- **Interface:** everything a caller must know to use the module correctly: signature plus invariants, ordering constraints, error modes, and configuration.
- **Depth:** behavior behind the interface relative to the interface's size. Shallow means the interface is nearly as complex as the implementation.
- **Seam:** where the interface lives; a place you can alter behavior without editing there (Feathers).
- **Adapter:** a concrete thing that satisfies an interface at a seam.

## Heuristics

- **The deletion test.** Imagine deleting the module. If complexity vanishes, it was a pass-through; if complexity reappears across callers, it earned its keep.
- **The interface is the test surface.** If you need to test past the interface, the module is probably the wrong shape.
- **One adapter is a hypothetical seam; two is a real one.** Don't introduce a seam unless something actually varies across it.
- **Depth is a property of the interface.** Internal composition from small parts is fine; exposing those parts through the interface is not.
- **Reader load is layers-to-trace plus state-to-hold,** not file count. Collapse wrappers with a single caller; shrink the scope of mutable state.

## Red Flags

Screen every interface, proposed or existing, against these. Assume the next contributor is an agent that sees only the files it opened, copies the nearest example, and takes the shortest path that compiles: prefer the shape where a change that looks right from one file is right for the whole system.

- **Shallow module:** callers coordinate several calls to complete one operation, or public options expose internal stages.
- **Information leakage:** one internal decision (representation, policy, protocol detail) appears in more than one module, so changing it requires coordinated edits. Re-exporting transport, storage, or framework types through a public surface is leakage (see [boundary-discipline](./boundary-discipline.md)).
- **Temporal decomposition:** modules split by execution order (load, validate, transform, save) instead of the knowledge they own. Group by the decisions a module protects.
- **Pass-through method:** forwards the same arguments to a method of the same shape. Remove it unless it adds policy, adaptation, or a distinct abstraction.
- **Split ownership:** more than one module writes the same state or keeps its own copy. Give each piece of state one owner; others read it or ask the owner to change it.
- **Two ways to do one task:** whichever is found first gets copied. Keep one; move callers off the others and delete them in the same change.
- **Importable internals:** whatever compiles becomes interface. Make internals unreachable, so an outside import fails the build.
- **Hand-synced list:** adding an item means editing several lists, and an editor who sees one updates one. Derive the others from a single list; if one can't be derived, fail the build when they disagree.

A deep module is not a deep call chain: a chain scatters understanding across layers; a deep module concentrates it behind one interface.

## Deepening Safely

When merging shallow modules into a deeper one, the dependency type sets the test strategy:

- **In-process** (pure computation, in-memory state): merge and test through the new interface.
- **Local-substitutable** (in-memory filesystem, embedded DB): test with the stand-in.
- **Remote but owned:** define a port at the seam; tests use an in-memory adapter.
- **True external:** inject the dependency as a port; tests use a mock adapter.

**Replace tests, don't layer them.** Write no new tests below the deepened seam. Delete internal tests that duplicate interface coverage unless they keep unique diagnostic or regression value. A test that breaks when the implementation changes but the interface doesn't is testing past the seam.
