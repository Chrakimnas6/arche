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

The scan always ends with an explicit outcome. If it genuinely surfaces nothing, report "No durable learnings this session" and stop — an explicit empty result, not a silently skipped step. A self-review gated on "if something noteworthy came up" reads as optional and never fires; running the scan unconditionally and stating the empty result is what keeps the step honest.

## Step 2 — Categorize and Route

For each learning, determine where it belongs. Route by `docs/principles/encode-lessons-in-structure.md`.

Routing priority, highest first:

1. **Structural enforcement** — a lint rule, script, hook, or automated check. This is the highest-value outcome.
2. **AGENTS.md** — project conventions, build commands, and gotchas the agent can't infer from code. Add only what the agent repeatedly gets wrong.
3. **Skill updates** — a skill's method was inadequate.
4. **Principles** — rare; principles are meant to be general.
5. **docs/** — architecture decisions and design rationale, in `docs/design/`.

## Step 3 — Present Proposals

Present each proposal with its target, what changes, why, and a priority. Ask the user which to apply.

## Step 4 — Apply Approved Changes

Apply each approved change directly. For a significant skill redesign, use `skill-creator`.

## Step 5 — Summary

After applying changes, output a brief summary: what was changed where, and how many proposals were skipped.
