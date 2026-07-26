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

## Step 1 — Scan the Conversation

Review the conversation for corrections, mistakes and their root causes, undocumented project conventions, tool/library quirks, workflow friction, and decisions worth their rationale.

Skip anything one-off, already documented, or with no applicability beyond this task.

## Step 2 — Categorize and Route

For each learning, determine where it belongs. Route by `docs/principles/encode-lessons-in-structure.md`.

### Routing priority (highest to lowest):

**1. Structural enforcement** — Can this be a lint rule, script, hook, or automated check?
- Example: "Agent keeps editing generated files by hand" → add a CI check that fails when generated output drifts from its source
- Example: "Tests must pass before committing" → add a pre-commit hook
- If yes, propose the structural change. This is the highest-value outcome.

**2. AGENTS.md** — Project-specific conventions, build commands, gotchas the agent can't infer from code.
- Example: "Always run `go generate ./...` before testing" → add to Commands section
- Example: "Never modify files in `contracts/deployed/`" → add to Conventions section
- Keep it lean — only add things the agent repeatedly gets wrong.

**3. Skill updates** — If a skill's methodology was inadequate, propose an improvement.
- Example: "Plan skill created phases that were too large for this codebase" → adjust phase sizing guidance
- Example: "pre-landing-review skill missed a common pattern in Go error handling" → add to checklist
- Note: use `skill-creator` for significant skill redesigns. Small additions can be edited directly.

**4. Principles** — If a principle needs project-specific elaboration or a new principle emerged.
- Example: "In this project, idempotency is critical because of the retry queue" → add note to `make-operations-idempotent.md`
- This should be rare — principles are meant to be general.

**5. docs/** — Architecture decisions, design rationale, context worth persisting.
- Example: "We chose proxy pattern over diamond for upgradeability because..." → `docs/design/`
- Example: "The indexer service depends on events from L1, here's the flow..." → `docs/design/`

## Step 3 — Present Proposals

Present each proposal with its target, what changes, why, and a priority. Ask the user which to apply.

## Step 4 — Apply Approved Changes

For each approved change:
- **AGENTS.md**: Edit directly
- **Skills**: Use `skill-creator` for significant redesigns. For small additions (a new line in a rationalization table, a gotcha), edit directly.
- **Principles**: Edit directly
- **docs/**: Create or edit files directly
- **Structural**: Create scripts, hooks, or config changes

## Step 5 — Summary

After applying changes, output a brief summary: what was changed where, and how many proposals were skipped.
