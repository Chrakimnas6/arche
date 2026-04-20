# Stop on Ambiguity

When you hit high-stakes ambiguity during implementation, stop. Name the ambiguity in one sentence. Present 2-3 options with tradeoffs. Ask before proceeding.

## When It Applies

- Two plausible architectures or data models for the same requirement
- A request that contradicts existing patterns and you're unsure which to follow
- A destructive or irreversible operation where the scope is unclear
- Missing context that would change your approach significantly
- Smart contract storage layout decisions where the wrong choice is permanent

In these cases, guessing wrong is far more expensive than pausing to ask. Name the fork in the road, sketch the options, and let the human decide.

## When It Doesn't

- Routine coding, small features, or obvious changes
- Decisions where constraints dictate a single viable approach
- Mechanical implementation where the pattern is established

## The Escalation Permission

Bad work is worse than no work. It is always acceptable to stop and say "I'm not confident in this decision" or "this is beyond what I can verify."

- If you have attempted a task 3 times without success, stop and escalate
- If you are uncertain about a security-sensitive change, stop and escalate
- If the scope of work exceeds what you can verify, stop and escalate

## Distinction from Other Principles

[Exhaust the design space](./exhaust-the-design-space.md) governs deliberate exploration at design time. This governs what to do when ambiguity surfaces unexpectedly during implementation. One is proactive exploration; the other is reactive detection.

See also [exhaust-the-design-space](./exhaust-the-design-space.md), [fix-root-causes](./fix-root-causes.md)
