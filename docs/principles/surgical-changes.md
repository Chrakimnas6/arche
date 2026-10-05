# Surgical Changes

**Principle:** When editing existing code, touch only what the task requires. Every changed line should trace directly back to the user's request; if one doesn't, save it for a follow-up.

**Why:** a diff that mixes the requested change with adjacent "improvements" hides the change, invites unrelated regressions, and drags the drift along when the change is reverted or rebased.

## Pattern

- **Confine each edit to the asked scope and match existing style.** Don't refactor adjacent code because you'd write it differently.
- **Surface unrelated issues, don't fix them.** Mention dead code, bugs, or smells you spot; don't bundle the fix in.
- **Clean up your own orphans, not others'.** Remove imports, variables, and helpers that *your* change made unused; leave pre-existing dead code unless asked. The edit should leave no new dangling references, but must not become a vehicle for opportunistic cleanup.

## When It Doesn't Apply

- The user explicitly asks for a broader cleanup ("clean up this file", "refactor X").
- Surrounding code actively blocks the task: a helper must change to support the new behavior, or the fix only makes sense with a small adjacent adjustment.
- The pre-existing dead code is the bug being fixed; then the fix and the cleanup are the same change.
