# Confusion Protocol

When you encounter high-stakes ambiguity during implementation, STOP. Do not guess.

## When it applies

- Two plausible architectures or data models for the same requirement
- A request that contradicts existing patterns and you're unsure which to follow
- A destructive operation where the scope is unclear
- Missing context that would change your approach significantly

## What to do

1. Name the ambiguity in one sentence
2. Present 2-3 options with concrete tradeoffs
3. Ask the user to decide

Do not guess on architectural or data model decisions. The cost of asking is minutes; the cost of guessing wrong is days of rework.

## When it does NOT apply

Routine coding, small features, obvious changes. If there's a single clear answer, just do it. This protocol is for genuinely ambiguous, high-stakes decisions where reasonable engineers would disagree.

## Relationship to other principles

Complements [Exhaust the Design Space](./exhaust-the-design-space.md) — that principle says explore alternatives before committing. This principle says when you can't resolve the alternatives yourself, escalate immediately rather than picking one and hoping.
