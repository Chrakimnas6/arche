# Encode Lessons in Structure

**Principle:** Encode recurring fixes in mechanisms (tools, code, metadata, automation) rather than textual instructions. Every error, correction, and unexpected outcome is a learning signal -- capture it, route it, and close the loop.

**Why:** textual instructions need the reader to notice, remember, and comply, and are routinely ignored; lint rules, flags, runtime checks, and scripts enforce the rule without cooperation.

## Pattern

When you catch yourself writing the same instruction a second time:

1. Fix it at the highest level that works: make it impossible by design (one owner, one way, unreachable internals) → unrepresentable in types → a lint or CI check whose error names what to use instead (on a pattern already common, fail only when a change adds more) → a test → text, only for genuine judgment calls, made prominent with an example of the failure mode.
2. Prove the new check fails on a real past instance of the mistake.
3. Delete the instruction it replaces. A written rule that was broken again is a repeat: escalate it a level in the same change.

## Feedback Loop

- **Capture every correction.** When tests fail or a reviewer catches a mistake, decide whether it can recur; if so, record the fix. "I'll keep that in mind" does not persist across sessions.
- **Route to the right layer.** A one-off -> doc note. A recurring fix -> lint rule or CI check. A systemic issue -> principle.
- **Close the loop.** Apply the fix now or create a concrete task; a note about a lint rule that should exist is wasted until the rule exists.
