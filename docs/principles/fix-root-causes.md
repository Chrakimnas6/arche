# Fix Root Causes

**Principle:** When debugging, never paper over symptoms. Trace every problem to its root cause and fix it there.

## Why

Symptom fixes accumulate: each workaround makes the system harder to reason about, and the real bug remains. Root-cause fixes are slower upfront but reduce total debugging time across the project's lifetime.

## Pattern

- **Reproduce first.** If you can't reproduce it, you can't verify your fix.
- **Ask "why" until you hit bedrock.** The test fails -> the mock is wrong -> the interface changed -> the type doesn't match the runtime shape. Fix the type, not the mock.
- **Resist the urge to add guards.** Adding a nil check to silence a crash is a symptom fix. Why is it nil? Fix that.
- **A workaround that needs a paragraph to justify it is the wrong fix.** If the code only makes sense with a long comment explaining why the hack is necessary, the comment is a symptom of a design fault. Fix the code so the comment isn't needed, not the other way around.
- **Check for the pattern, not just the instance.** If one file has a bug, grep for the same pattern. Fix all instances, or make it structurally impossible.
- **When stuck, instrument -- don't guess.** Add logging, read the actual error.

## Restart Bugs: Suspect State Before Code

Code doesn't change between runs. State does. When "fails after restart," suspect stale persistent state first -- config files, caches, lock files, serialized state. If clearing a state file restores behavior, prioritize state validation as the fix.

## Own the Cause, Wherever It Lives

Follow the bug to its root even when the root is "pre-existing" or sits in code you didn't write. Don't stop at the nearest symptom because the real cause lives in another file, an older commit, or someone else's module — the causal chain is yours to chase to bedrock.

This governs *depth*, not *breadth*. Owning the cause means tracing the bug you were asked to fix all the way down; it does not mean adopting every unrelated lint error or smell in a file you happened to open. For issues that are not on the causal path, follow [surgical-changes](./surgical-changes.md): surface them, don't bundle the fix.
