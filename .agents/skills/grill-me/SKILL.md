---
name: grill-me
description: Interview the user relentlessly about a plan or design until reaching shared understanding, resolving each branch of the decision tree. Use when user wants to stress-test a plan, get grilled on their design, or mentions "grill me".
---

Interview me relentlessly about every aspect of this plan until we reach a shared understanding. Map the plan as a **design tree** — every decision branches into the decisions that hang off it — and walk each branch, respecting dependencies between decisions. Enter high-leverage branches first — questions whose answers would change data models, interfaces, or the shape of the plan — and defer questions that only tune details within a settled structure; a structural answer discovered late invalidates every branch resolved on top of it (`docs/principles/foundational-thinking.md`: structural decisions optimize for option value). For each question, provide your recommended answer.

Work the tree in **rounds**. The **frontier** is every decision whose prerequisites are already settled — the questions you can ask *now* without guessing at answers you haven't heard yet. Ask the whole frontier in one round, high-leverage questions first; a question whose answer depends on another question still open in this round belongs to a *later* round, not this one. Each answered round reshapes the tree — settled decisions push the frontier outward and unblock the questions that depended on them. Recompute the frontier and ask the next round.

Format each question in the round like so:

```
❓ **Q1 — <question title>**: <question body, may be multiple paragraphs, including choices>

➡️ <your recommended answer>
```

Split **facts** from **decisions**. If a *fact* can be found by exploring the environment — the codebase, the filesystem, tools, docs — look it up rather than asking me; finding facts is your job, never mine. When a frontier question needs a fact, dispatch a subagent to find it and don't block the round on it: a running exploration is an unsettled prerequisite, so only the questions downstream of it wait — ask the rest of the frontier now. The *decisions* are mine: put each one to me and wait for my answer. Don't answer a decision autonomously because you could infer it from the code — inference is not consent.

## Opening

**Blind-spot pass first.** Before the first question, list the dimensions the user's framing never mentions — failure modes, actors, lifecycle, integration points, operational concerns — and ask which belong in the design tree. Accepted ones become branches to walk; dismissed ones are deliberately-deferred questions for the Closing record.

## During the session

**Sharpen fuzzy language.** On a vague or overloaded term, propose a precise canonical one.

**State the stakes.** For each question, say what breaks or degrades if the answer is wrong.

**Stress-test with concrete scenarios.** Probe boundaries with specific hard cases; make the user commit to how each works.

**Prototypes, not pressure, for know-it-when-I-see-it questions.** When the honest answer is a preference the user can only judge by seeing concrete options (UX, API feel, output shape), don't force a verbal commitment — defer it, marking it *prototype-resolved* in the decision record: it resolves via 2-3 throwaway sketches (`docs/principles/experience-first.md`, `docs/principles/exhaust-the-design-space.md`).

**Cross-reference with code.** When the user states how something works, check whether the code agrees. If you find a contradiction, surface it: "Your code does X, but you just said Y — which is right?"

**Ask for references early.** Existing code — in this repo or an external one — that already does this the way the user wants is a spec with far fewer unknowns than prose. Ask once, early; if a reference is named, record its path in the decision record and treat it as settling the questions it answers.

## Closing

The interview is done when the frontier is empty: every branch of the design tree visited, nothing left silently assumed. Then write the decision record to `docs/design/<topic>-decisions.md`: each decision with its one-line why, plus any questions deliberately deferred. This is the artifact the `plan` skill consumes — without it, the interview's conclusions die with the session.
