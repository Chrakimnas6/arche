# Fix Root Causes

**Principle:** When debugging, never paper over symptoms. Trace every problem to its root cause and fix it there.

**Why:** each workaround makes the system harder to reason about while the real bug remains.

## Pattern

- **Reproduce first.** If you can't reproduce it, you can't verify the fix.
- **Ask "why" until you hit bedrock.** The test fails -> the mock is wrong -> the interface changed -> the type doesn't match the runtime shape. Fix the type, not the mock.
- **A guard is a fix only when the state it handles is legitimate.** Ask whether the system may be in the state that triggered the symptom. If it may, the code that broke on it is the root cause and handling the state there is the fix. If it should never exist, a nil check, retry, swallowed error, or clamped value where it broke hides the bug: find what produced the state.
- **A workaround that needs a paragraph to justify it is the wrong fix.** The long comment is a symptom of a design fault; fix the code so the comment isn't needed.
- **Check for the pattern, not just the instance.** Grep for the same bug elsewhere. Fix all instances, or make it structurally impossible.
- **When stuck, instrument -- don't guess.** Add logging, read the actual error. If the deciding fact took a deep dig to find, propose the cheap, always-on signal that would have shown it at first look ([observability](./observability.md)).
- **Restart bugs: suspect state before code.** Code doesn't change between runs; state does. When it "fails after restart," suspect stale config, caches, lock files, or serialized state first. If clearing a state file restores behavior, make state validation the fix.

## Own the Cause, Wherever It Lives

Follow the bug to its root even when the root is pre-existing or sits in code you didn't write: another file, an older commit, someone else's module. This governs *depth*, not *breadth*: issues off the causal path follow [surgical-changes](./surgical-changes.md) (surface them, don't bundle the fix).
