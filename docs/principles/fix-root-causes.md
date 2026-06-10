# Fix Root Causes

**Principle:** When debugging, never paper over symptoms. Trace every problem to its root cause and fix it there.

## Why

Symptom fixes accumulate: each workaround makes the system harder to reason about, and the real bug remains. Root-cause fixes are slower upfront but reduce total debugging time across the project's lifetime.

## Pattern

- **Reproduce first.** If you can't reproduce it, you can't verify your fix.
- **Ask "why" until you hit bedrock.** The test fails -> the mock is wrong -> the interface changed -> the type doesn't match the runtime shape. Fix the type, not the mock.
- **Resist the urge to add guards.** Adding a nil check to silence a crash is a symptom fix. Why is it nil? Fix that.
- **Check for the pattern, not just the instance.** If one file has a bug, grep for the same pattern. Fix all instances, or make it structurally impossible.
- **When stuck, instrument -- don't guess.** Add logging, read the actual error.

## Restart Bugs: Suspect State Before Code

Code doesn't change between runs. State does. When "fails after restart," suspect stale persistent state first -- config files, caches, lock files, serialized state. If clearing a state file restores behavior, prioritize state validation as the fix.

## Own the Cause, Wherever It Lives

Follow the bug to its root even when the root is "pre-existing" or sits in code you didn't write. Don't stop at the nearest symptom because the real cause lives in another file, an older commit, or someone else's module — the causal chain is yours to chase to bedrock.

This governs *depth*, not *breadth*. Owning the cause means tracing the bug you were asked to fix all the way down; it does not mean adopting every unrelated lint error or smell in a file you happened to open. For issues that are not on the causal path, follow [surgical-changes](./surgical-changes.md): surface them, don't bundle the fix.

## Relationship to Other Principles

[Prove it works](./prove-it-works.md) says to check real state, not proxies. This extends that to debugging: check the real cause, not the proxied symptom.

[Encode lessons in structure](./encode-lessons-in-structure.md) provides the encoding mechanism once a root cause is understood -- make it structurally impossible to recur.

## Citations

Imai, *Kaizen: The Key to Japan's Competitive Success* (McGraw-Hill, 1986) — Toyota's "5 Whys" methodology for tracing causes back to bedrock. Hunt & Thomas, *The Pragmatic Programmer* (1999) — "Programming by Coincidence" anti-pattern; debug deliberately. Agans, *Debugging: The 9 Indispensable Rules* (AMACOM, 2002) — "Understand the system" + "Make it fail" as systematic root-cause discipline.
