---
name: reflect
description: >-
  Post-task learning capture. Reviews the conversation for mistakes, corrections,
  and discoveries, then proposes updates to AGENTS.md, skills, principles, or docs.
  Use after completing significant work, when wrapping up a session, after mistakes
  or corrections, or when the user says "reflect", "what did we learn", or "remember this".
---

# Reflect

Capture learnings from the current session and route them to the right place in the project. **Do NOT make changes without user approval** — present proposals and let the user decide.

## When to Use

- After completing a significant feature or bug fix
- After a session where mistakes were made and corrected
- When the user says "reflect", "what did we learn?", or "remember this"
- When you notice recurring friction that could be eliminated

## Step 1 — Scan the Conversation

Review the current conversation for:

1. **Corrections the user made** — "no, don't do it that way", "that's wrong", "use X instead"
2. **Mistakes and their root causes** — what went wrong and why
3. **Project conventions discovered** — patterns, naming, architecture decisions that aren't documented
4. **Tool/library quirks** — unexpected behavior, workarounds, version-specific gotchas
5. **Workflow friction** — steps that were slow, confusing, or repeated unnecessarily
6. **Decisions and rationale** — why a particular approach was chosen over alternatives

**Skip:**
- Trivial one-off issues unlikely to recur
- Things already documented in AGENTS.md, skills, or docs/
- Task-specific details with no broader applicability

## Step 2 — Categorize and Route

For each learning, determine where it belongs. Prefer structural enforcement over documentation — making something impossible beats documenting that it shouldn't happen.

### Routing priority (highest to lowest):

**1. Structural enforcement** — Can this be a lint rule, script, hook, or automated check?
- Example: "Agent keeps running `rm -rf` on test fixtures" → add pattern to `check-careful.sh`
- Example: "Tests must pass before committing" → add a pre-commit hook
- If yes, propose the structural change. This is the highest-value outcome.

**2. AGENTS.md** — Project-specific conventions, build commands, gotchas the agent can't infer from code.
- Example: "Always run `go generate ./...` before testing" → add to Commands section
- Example: "Never modify files in `contracts/deployed/`" → add to Conventions section
- Keep it lean — only add things the agent repeatedly gets wrong.

**3. Skill updates** — If a skill's methodology was inadequate, propose an improvement.
- Example: "Plan skill created phases that were too large for this codebase" → adjust phase sizing guidance
- Example: "Review skill missed a common pattern in Go error handling" → add to checklist
- Note: use `skill-creator` for significant skill redesigns. Small additions can be edited directly.

**4. Principles** — If a principle needs project-specific elaboration or a new principle emerged.
- Example: "In this project, idempotency is critical because of the retry queue" → add note to `make-operations-idempotent.md`
- This should be rare — principles are meant to be general.

**5. docs/** — Architecture decisions, design rationale, context worth persisting.
- Example: "We chose proxy pattern over diamond for upgradeability because..." → `docs/design/`
- Example: "The indexer service depends on events from L1, here's the flow..." → `docs/design/`

## Step 3 — Present Proposals

Present each proposed change to the user in a clear format:

```
## Proposed Changes

### 1. [AGENTS.md] Add go generate command
**What:** Add `go generate ./...` to the Commands section
**Why:** Agent forgot to run it twice this session, causing test failures
**Priority:** HIGH — affects every test run

### 2. [Skill: plan] Reduce max phase size for Go projects
**What:** Add note that Go projects with small packages should use 1-2 files per phase, not 2-3
**Why:** Three phases were too large and had to be split mid-implementation
**Priority:** MEDIUM — improves planning accuracy

### 3. [docs/design/] Document event sourcing architecture
**What:** Create docs/design/event-sourcing.md with the architecture decided today
**Why:** Complex decision with trade-offs that will be needed for future features
**Priority:** LOW — useful context but not blocking
```

Ask the user which changes to apply.

## Step 4 — Apply Approved Changes

For each approved change:
- **AGENTS.md**: Edit directly
- **Skills**: Use `skill-creator` for significant redesigns. For small additions (a new line in a rationalization table, a gotcha), edit directly.
- **Principles**: Edit directly
- **docs/**: Create or edit files directly
- **Structural**: Create scripts, hooks, or config changes

## Step 5 — Summary

After applying changes, output a brief summary:

```
## Reflection Complete

- AGENTS.md: added go generate command
- docs/design/event-sourcing.md: created
- 1 proposal skipped (user declined)
```

## Anti-Patterns

| Bad | Good |
|-----|------|
| Capturing every minor detail | Focus on recurring patterns and significant decisions |
| Adding to AGENTS.md what the code already shows | Only document what the agent can't infer |
| Updating principles for one-off situations | Principles are general — use docs/ for specifics |
| Making changes without asking | Always present and get approval first |
| Reflecting after trivial tasks | Reserve for significant work or explicit request |
