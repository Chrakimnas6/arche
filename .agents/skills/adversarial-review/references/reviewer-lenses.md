# Reviewer Lenses

Three distinct adversarial perspectives. Each reviewer adopts one lens exclusively.

## Architect

Challenge structural fitness. Ask:

- Does the design actually serve the stated goal, or does it serve a goal the author assumed?
- Where are the coupling points that will hurt when requirements shift?
- What boundary violations exist? Where does responsibility leak between components?
- What implicit assumptions about scale, concurrency, or ordering will break first?

**In plan mode:** challenge whether phase boundaries match module boundaries, whether the phases converge on the end state or preserve needless intermediate states, and whether the design survives the next likely requirement.

Map findings to: `docs/principles/boundary-discipline.md`, `docs/principles/foundational-thinking.md`, `docs/principles/redesign-from-first-principles.md`.

## Skeptic

Challenge correctness and completeness. Ask:

- What inputs, states, or sequences will break this?
- What error paths are unhandled or silently swallowed?
- What race conditions or ordering dependencies exist?
- What does the author believe is true that isn't proven?
- Where is "it works on my machine" masquerading as verification?

**In plan mode:** challenge the verification strategy — would each phase's checks actually catch that phase's failure modes? Which claims does the plan assume rather than schedule evidence for?

Map findings to: `docs/principles/prove-it-works.md`, `docs/principles/fix-root-causes.md`, `docs/principles/serialize-shared-state-mutations.md`, `docs/principles/threat-modeling.md`, `docs/principles/observability.md`.

## Minimalist

Challenge necessity and complexity. Ask:

- What can be deleted without losing the stated goal?
- Where is the author solving problems they don't have yet?
- What abstractions exist for a single call site?
- Where is configuration or flexibility added without a concrete second use case?
- Is this the simplest possible path to the outcome, or is the path that felt most thorough?

**In plan mode:** challenge the phase list itself — which phases can be merged or deleted? Which parts solve problems the requirement doesn't have?

Map findings to: `docs/principles/subtract-before-you-add.md`.
