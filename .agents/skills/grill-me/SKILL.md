---
name: grill-me
description: Interview the user relentlessly about a plan or design until reaching shared understanding, resolving each branch of the decision tree. Use when user wants to stress-test a plan, get grilled on their design, or mentions "grill me".
---

Interview me relentlessly about every aspect of this plan until we reach a shared understanding. Walk down each branch of the design tree, resolving dependencies between decisions one-by-one. Enter high-leverage branches first — questions whose answers would change data models, interfaces, or the shape of the plan — and defer questions that only tune details within a settled structure; a structural answer discovered late invalidates every branch resolved on top of it (`docs/principles/foundational-thinking.md`: structural decisions optimize for option value). For each question, provide your recommended answer.

Ask the questions one at a time.

Split **facts** from **decisions**. If a *fact* can be found by exploring the environment — the codebase, the filesystem, tools, docs — look it up rather than asking me; finding facts is your job, never mine. The *decisions* are mine: put each one to me and wait for my answer. Don't answer a decision autonomously because you could infer it from the code — inference is not consent.

## Opening

**Blind-spot pass first.** Before the first question, list the dimensions the user's framing never mentions — failure modes, actors, lifecycle, integration points, operational concerns — and ask which belong in the design tree. Accepted ones become branches to walk; dismissed ones are deliberately-deferred questions for the Closing record.

## During the session

**Sharpen fuzzy language.** When the user uses vague or overloaded terms, propose a precise canonical term. "You're saying 'account' — do you mean the Customer or the User? Those are different things."

**State the stakes.** For each question, say what breaks or degrades if the answer is wrong — this forces the user to weigh the decision properly rather than hand-wave.

**Stress-test with concrete scenarios.** When relationships or boundaries are discussed, invent specific scenarios that probe edge cases and force the user to be precise. Don't accept hand-waving — make them commit to how it works in the hard cases.

**Prototypes, not pressure, for know-it-when-I-see-it questions.** When the honest answer is a preference the user can only judge by seeing concrete options (UX, API feel, output shape), don't force a verbal commitment — defer it, marking it *prototype-resolved* in the decision record: it resolves via 2-3 throwaway sketches (`docs/principles/experience-first.md`, `docs/principles/exhaust-the-design-space.md`).

**Cross-reference with code.** When the user states how something works, check whether the code agrees. If you find a contradiction, surface it: "Your code does X, but you just said Y — which is right?"

**Ask for references early.** Existing code — in this repo or an external one — that already does this the way the user wants is a spec with far fewer unknowns than prose. Ask once, early; if a reference is named, record its path in the decision record and treat it as settling the questions it answers.

## Closing

When every branch is resolved, write the decision record to `docs/design/<topic>-decisions.md`: each decision with its one-line why, plus any questions deliberately deferred. This is the artifact the `plan` skill consumes — without it, the interview's conclusions die with the session.
