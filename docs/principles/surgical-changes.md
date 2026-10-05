# Surgical Changes

When editing existing code, touch only what the task requires. Every changed line should trace directly back to the user's request.

## The Pattern

- **Confine each edit to the asked scope and match existing style** — don't refactor adjacent code just because you'd write it differently.
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
