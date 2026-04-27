# Redesign From First Principles

When integrating a change, don't bolt it onto the existing design. Instead, redesign as if the change had been a foundational assumption from the start. The result should be the most elegant solution that would have emerged if we'd known about this requirement on day one.

- Read all affected files and understand the current design holistically
- Ask: "if we were writing this from scratch with this new requirement, what would we build?"
- Propagate the change through every reference -- types, docs, examples, rationale sections -- so nothing reads as a patch
- The redesign should be thought of holistically but delivered incrementally

This is the method for preserving [option value](./foundational-thinking.md) when integrating changes into an existing design. Language-specific applications live in [docs/applications/](../applications/).

## Citations

Brooks, *The Mythical Man-Month* (1975), chapter 11 "Plan to Throw One Away" — the first system you build is rarely the right one. Fowler, *Refactoring* (2nd ed., 2018) — refactor toward the design you'd choose now, in small steps.
