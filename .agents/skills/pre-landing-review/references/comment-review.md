# Comment Review

Use before handing off code or completing a review when the change adds or modifies handwritten comments. This is a focused review of the current change, not a cleanup of existing comments.

## Review every changed block

1. Collect added or modified comment blocks from the scoped diff, including production code and tests. Include new untracked files that belong to the change; a tracked-file diff does not show them. Read each block with its declaration or surrounding code. Match comments in the source language, not comment-like text inside strings or fixtures.
2. Leave generated output to its generator. Preserve comments required by tools or explicit project conventions: license headers, directives, required API documentation, and prescribed section markers. Exported visibility alone is not a documentation requirement.
3. For each remaining block, identify the fact a reader cannot recover from the nearby code. Keep non-obvious invariants, external constraints, and explanations of why an apparently simpler implementation fails. Remove restatements of names, statements, assertions, ordinary mock behavior, and implementation or review history. Existing comment density is not a target.
4. When a block mixes a useful fact with narration, retain the fact and trim the narration. Do not refactor unrelated code or add helpers merely to eliminate a comment. If usefulness remains uncertain, retain the block and report the specific uncertainty.

| Comment and context | Decision |
|---|---|
| Says a function returns sorted keys; the body obtains keys, sorts, and returns them | Remove the restatement |
| Says a response format was not requested; the test already names the unsupported format and asserts its error | Remove the task history |
| Explains that a generated boolean type cannot distinguish omission from explicit false, requiring a local pointer type | Keep the external representation constraint |
| Explains why a recovery query cannot reuse a Postgres transaction after a unique violation | Keep the failure semantics |

## Complete the review

Apply clear comment-only corrections within the authorized editing scope. In a read-only review, report them instead. Follow project-specific review severity; a project blocking rule is not downgraded to advisory by a generic code-quality category. Uncertain findings remain visible for review, not silently accepted as compliant.

Include one line in the handoff or review report: `Comment review: N blocks checked; D removed; S shortened; U unresolved.` In read-only mode, use `D proposed removals; S proposed shortenings` instead; never label an unapplied change as removed or shortened. Count each added or modified handwritten block once, including preserved required comments. Put explanations and unresolved file/line references in the report, not in new source comments. If there are no changed handwritten comments, skip the checklist and report `Comment review: no changed handwritten comments.`
