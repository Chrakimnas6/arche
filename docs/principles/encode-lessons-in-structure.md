# Encode Lessons in Structure

**Principle:** Encode recurring fixes in mechanisms (tools, code, metadata, automation) rather than textual instructions. Every error, correction, and unexpected outcome is a learning signal -- capture it, route it, and close the loop.

## Why

Textual instructions ("always run fmt", "do not skip linting") are routinely ignored. They require the reader to notice, remember, and comply. Structural mechanisms -- lint rules, metadata flags, runtime checks, automation scripts -- enforce the rule without cooperation.

## Pattern

When you catch yourself writing the same instruction a second time:

1. Fix it at the highest level that works: make it impossible by design (one owner, one way, unreachable internals) → unrepresentable in types → a lint or CI check whose error names what to use instead (on a pattern already common, fail only when a change adds more) → a test → text, only for genuine judgment calls, made prominent with an example of the failure mode.
2. Prove the new check fails on a real past instance of the mistake.
3. Delete the instruction it replaces. A written rule that was broken again is a repeat: escalate it a level in the same change.

**Corollary -- don't paper over symptoms.** If the fix is structural, ONLY use the structural fix. The instruction IS the symptom -- if you're writing "don't do X" in a prompt, ask whether you can make X impossible instead.

## Feedback Loop

- **Capture every correction.** When tests fail or a reviewer catches a recurring mistake, decide if it's a one-off or a pattern. If it can recur, record the fix.
- **Route to the right layer.** A one-off -> doc note. A recurring fix -> lint rule or CI check. A systemic issue -> principle.
- **Close the loop.** Don't only record -- apply now or create a concrete task.

## Anti-Patterns

- **Acknowledging without recording.** "I'll keep that in mind" does not persist across sessions.
- **Recording without routing.** A note about a lint rule that should exist is wasted unless the lint rule gets implemented.
- **Fixing without generalizing.** Fixing one instance while leaving the recurring pattern intact.

## Citations

Hunt & Thomas, *The Pragmatic Programmer* (1999) — "DRY" extended to process: don't repeat yourself across instructions and reviews when a tool or check can enforce the rule. Fowler, *Refactoring* (2nd ed., 2018) — making the change easy by mechanizing the recurring transformation. Brooks, *The Mythical Man-Month* (1975) — "conceptual integrity" emerges from structures, not instructions.
