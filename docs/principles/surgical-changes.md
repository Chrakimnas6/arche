# Surgical Changes

When editing existing code, touch only what the task requires. Every changed line should trace directly back to the user's request.

## The Pattern

- **Confine the edit to the asked scope.** Don't "improve" adjacent code, comments, or formatting along the way.
- **Match existing style** even if you'd write it differently in a greenfield project. Style consistency is more valuable inside a working codebase than personal preference.
- **Don't refactor what isn't broken.** If you'd structure something differently but it isn't related to the task, leave it.
- **Surface unrelated issues, don't fix them.** If you spot dead code, a bug, or a smell while making your change, mention it — but don't bundle the fix in.

## Clean Up Your Own Mess, Not Others'

When your changes orphan code:

- Remove imports, variables, helpers, and functions that *your* changes made unused.
- Don't remove pre-existing dead code unless explicitly asked.

The asymmetry is intentional: your edit should leave the file in the same coherence-state you found it (no new dangling references), but should not become a vehicle for opportunistic cleanup.

## Why

Large diffs that mix the requested change with adjacent "improvements" are hard to review, hide the actual change, and frequently introduce regressions that have nothing to do with the original task. Reviewers waste effort mentally separating "the fix" from "the drift." Worse, when the requested change is later reverted or rebased, the unrelated edits ride along or get left behind as orphans.

Surgical changes also make intent legible. A diff that touches only what the task needs is self-explaining. A diff that touches twenty lines for what was supposed to be a one-line fix invites suspicion and slows trust.

## The Test

For every changed line, ask: *"Does this trace directly to what was asked?"* If no, it doesn't belong in this change. Save it for a follow-up.

## When It Doesn't Apply

- When the user explicitly asks for a broader cleanup ("clean up this file", "refactor X").
- When the surrounding code is actively blocking the task — e.g., a helper must be modified to support the new behavior, or a fix only makes sense alongside a small adjacent adjustment.
- When pre-existing dead code is the bug the task is meant to fix. In that case the fix and the cleanup are the same change.

## Distinction from Other Principles

[Subtract before you add](./subtract-before-you-add.md) governs *what to build* — delete obsolete paths before constructing new ones, as a deliberate design move. This governs *how to edit* — when making a change, don't let scope creep in. One is planned simplification at design time; the other is restraint during routine implementation.

[Stop on ambiguity](./stop-on-ambiguity.md) tells you to pause when scope or approach is unclear. This tells you what to do when the scope *is* clear: stay inside it.

## Citations

Fowler, *Refactoring* (2nd ed., 2018) — Kent Beck's "Two Hats" metaphor: refactoring and adding function are distinct modes; never wear both at once in a single change. Beck, *Tidy First?* (O'Reilly, 2023) — distinguishes "tidyings" (small structural changes) from behavioral changes, and argues they belong in separate commits/PRs.
