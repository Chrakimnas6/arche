---
name: plan
description: >-
  Systematic planning for features and projects. Gathers context, explores codebase,
  writes phased implementation plans to docs/plans/. Two modes: greenfield (from requirements)
  and feature (incremental changes). Does NOT implement. Use when asked to "plan this",
  "break this down", "design this", or starting a new feature.
---

# Plan

Produce implementation plans grounded in project principles. Write plans to `docs/plans/`.

**Do NOT implement anything. The plan is the deliverable.** This is a hard gate. No code, no scaffolding, no "just this one file." The output is a written plan. Stop after writing it.

## Two Modes

Determine which mode applies before starting:

**Greenfield** — Starting from detailed requirements with no existing codebase to integrate into. Design architecture from scratch. Skip the codebase exploration parts of Step 3 that look for existing patterns; instead, focus exploration on understanding the requirements document, researching relevant technologies, and mapping out the system design.

**Feature** — Adding to or changing an existing codebase. Explore the codebase thoroughly before designing. Understand existing patterns, conventions, and architecture so the plan fits naturally into what's already there.

State the mode in the plan overview.

## Step 0 — Triage Complexity

Before running the full planning workflow, assess whether this task actually needs a plan:

**Trivially small (1-2 files, obvious approach):**
Tell the user this task doesn't need a plan and suggest implementing directly without the plan skill. **Stop here — do not implement.**

**Needs planning (proceed to Step 1):**
- The change spans 3+ files or introduces new architecture
- There are multiple valid approaches and the user should weigh in
- The task has unclear scope or cross-cutting concerns
- The user explicitly asks for a plan

## Step 1 — Load Principles

Read `docs/principles/index.md`. Follow every link and read each linked principle file. These principles govern all plan decisions — cite them by name in the plan overview and phase files.

**Do NOT skip this. Do NOT use memorized principle content — always read fresh.** The self-check in Step 5b will verify citations exist.

If `docs/principles/index.md` does not exist, note the absence and proceed without principle citations. Do not create the file.

## Step 2 — Define Scope and Constraints

Resolve ambiguity before exploring the codebase:

- What is in scope vs explicitly out of scope?
- Are there constraints (dependencies, platform requirements, existing patterns to preserve)?
- What does "done" look like?

Frame questions with concrete options. If the request is already clear, confirm scope boundaries briefly and move on.

## Step 3 — Explore Context with Subagents

**Always** delegate exploration to subagents. Never do large-scale codebase exploration in the main context.

Spawn exploration subagents to:
- Read existing code in affected areas
- Identify patterns, conventions, and dependencies
- Map architecture relevant to the change
- Find tests, types, and related infrastructure

Run multiple agents in parallel when investigating independent areas.

**Greenfield mode:** Focus subagents on reading requirements docs, researching technology choices, and exploring reference implementations if any exist.

**Feature mode:** Focus subagents on understanding the existing codebase — file structure, patterns, conventions, test infrastructure, and the specific areas the change will touch.

## Step 4 — Write the Plan

Create the plan using file tools. Output location: `docs/plans/<plan-name>/`.

### Directory Structure

```
docs/plans/<plan-name>/
  overview.md
  phase-01-<slug>.md
  phase-02-<slug>.md
  ...
```

Non-phase files (like `testing.md`) are fine alongside phases.

### Overview File

Must include:
- **Mode** — greenfield or feature
- **Context** — what problem this solves and why
- **Scope** — what's included, what's explicitly excluded
- **Constraints** — technical, platform, dependency, or pattern constraints. Include the alternatives check here (see below).
- **Principles** — which project principles apply and how they shaped decisions (if `docs/principles/index.md` exists)
- **Phases** — ordered list with links to phase files
- **Verification** — project-level verification commands (e.g. `go test ./...`, `go vet ./...`)

### Phase Files

Each phase file must include:
- Back-link to the overview
- **Goal** — what this phase accomplishes
- **Changes** — which files are affected and what changes, described at a high level
- **Data structures** — name the key types/schemas before logic, but a one-line sketch is enough — don't write full definitions
- **Verification** — static and runtime checks for this phase (see verification section below)

**Keep plans high-level.** Describe *what* and *why*, not *how* at the code level. A phase should read like a brief to a senior engineer: goals, boundaries, key types, and verification — not code snippets or pseudocode.

Order phases so that infrastructure and shared types come first, features after. Each phase should be independently shippable.

### Phase Sizing

- **1 function/type + tests** per phase, or **1 bug fix** — not "one file" or "one component" (too variable)
- **Max 2-3 files touched** per phase when possible
- **Prefer 8-10 small phases** over 3-4 large ones — small phases keep future options open
- If a phase lists >5 test cases or >3 functions, split it

### Redesign Check

For changes touching existing code, apply redesign-from-first-principles:
> "If we were building this from scratch with this requirement, what would we build?"

Don't bolt changes onto existing designs — redesign holistically.

### Alternatives Check

For architectural decisions, briefly sketch 2-3 approaches in the overview's Constraints section. State which was chosen and why. This prevents premature commitment and documents the design space explored.

### Verification Strategy

Every phase **must** have a verification section with both:

**Static:**
- Type checking passes
- Linting passes
- Code follows project conventions
- Tests written and passing

**Runtime:**
- What to test manually (launch the app, exercise the feature path)
- What automated tests to write (unit, integration, e2e)
- Edge cases to cover
- For UI: visual verification via screenshot

"It compiles" is not verification. Every phase must describe how to **prove** the change works.

## Step 4b — Self-Check

After writing all plan files, verify these three constraints before proceeding. Fix any violations before moving on.

**Principles cited (if applicable):** If `docs/principles/index.md` exists, the overview must reference at least 2 principles by name. If not, re-read the principles and add the most relevant ones to the overview's design decisions.

**Phase sizing:** Review each phase. If any phase touches >3 files or lists >5 test cases, split it into smaller phases. Count the files listed under "Changes" — if the list exceeds 3, the phase is too big.

**No code in phases:** Phase files must not contain code blocks. Name types and functions but do not define them. A phase should read like a brief to a senior engineer, not a diff or implementation spec. If you find code blocks, replace them with prose describing the intended shape.

## Step 5 — Present and Stop

Summarize the plan: list the phases, scope boundaries, and verification approach. Point the user to the plan files in `docs/plans/<plan-name>/`.

**Stop here. Do NOT begin implementation.** The plan is the deliverable. The user decides when and how to execute the plan.
