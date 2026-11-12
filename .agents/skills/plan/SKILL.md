---
name: plan
description: >-
  Write a phased implementation plan to docs/plans/ from requirements or a decision record.
  Does NOT implement. Use when asked to "plan this", "break this down", "design this", or
  when starting a feature that spans several files or has more than one viable approach.
---

# Plan

Write an implementation plan to `docs/plans/<plan-name>/`. **The plan is the deliverable: no code, no scaffolding. Stop after writing it.** If the change is one or two files with an obvious approach, say it needs no plan and stop.

## 1. Load the principles

Read every principle in full with one command: `cat docs/principles/*.md`, or `cat ~/src/github.com/Chrakimnas6/arche/docs/principles/*.md` when the project has no `docs/principles/`.

## 2. Settle scope

If a grill-me decision record exists (`docs/design/<topic>-decisions.md`), read it first: its resolved decisions are settled, so don't re-ask them. A question it marks *prototype-resolved* becomes an early throwaway-spike phase that builds the 2-3 sketches and gates dependent phases on the user's pick.

Resolve what remains open before designing: scope boundaries, constraints, and the definition of done. Ask with concrete options and say what breaks if the choice is wrong.

## 3. Explore

Read the code the change touches. Delegate broad exploration to subagents and wait for all of them before writing. Check each factual premise before designing on it: every command, flag, route, or API the plan names exists, and the work isn't already on the base branch. List a premise you couldn't check as unverified under Constraints.

## 4. Write the plan

```
docs/plans/<plan-name>/
  overview.md
  phase-01-<slug>.md
  phase-02-<slug>.md
```

**`overview.md`** has:

- **Context** — the problem and why it matters
- **Key decisions** — the decisions a reviewer is most likely to contest (data models, interfaces, user-visible behavior). For each: 2-3 approaches that differ in kind, the one chosen, and why. Decisions settled in a decision record are cited, not re-opened.
- **Scope** — what is included and what is explicitly excluded
- **Constraints**
- **Principles** — only the principles that changed a decision, each with the decision it changed. A principle that changed nothing is not listed.
- **Phases** — ordered links to the phase files
- **Verification** — the project-level commands

**Each phase file** has a back-link to the overview, then:

- **Goal** — one outcome
- **Changes** — which files change and how, at a high level
- **Data structures** — the key types or schemas, each named with a one-line sketch
- **Verification** — the project's static commands, plus at least one runnable check whose exit code or output decides pass or fail. A manual check states its observable pass condition ("dashboard renders three panels with non-zero counts", not "visual verification"). "It compiles" is not verification.

A phase reads like a brief to a senior engineer: what and why, with no code blocks or pseudocode. Verification commands are not code.

**Size each phase** as the smallest increment that ships and verifies on its own: its verification passes without any later phase, and the codebase is coherent if the next phase never runs. Split a phase whose Goal needs "and" between unrelated outcomes; merge one that can't be verified without the next.

## 5. Present and stop

Summarize the phases, scope boundaries, and verification approach, and point to the plan files. The user decides when to execute.
