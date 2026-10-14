# Redesign From First Principles

**Principle:** When integrating a change, don't bolt it onto the existing design. Redesign as if the change had been a foundational assumption from day one.

- Ask: "if we were writing this from scratch with this requirement, what would we build?" Read the affected files first, so the answer covers the whole design.
- Propagate the change through every reference (types, docs, examples, rationale sections) so nothing reads as a patch.
- Think the redesign through holistically; deliver it incrementally.
