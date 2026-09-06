# Verdict Format

```
## Intent
<what the author is trying to achieve>

## Reviewed
<head SHA> against <base SHA>; patch-id <output of `git diff <base> <head> | git patch-id --stable`>
(Plan mode: the plan files and the commit they were read at.)

## Verdict: PASS | CONTESTED | REJECT
<one-line summary>

## Findings
<numbered list, ordered by severity (high -> medium -> low)>

For each finding:
- **[severity]** Description with file:line references
- Lens: which reviewer raised it
- Principle: which principle file from docs/principles/ it maps to
- Recommendation: concrete action, not vague advice

## What Went Well
<1-3 things the reviewers found no issue with -- acknowledge good work>

## Lead Judgment
<for each finding: accept or reject with a one-line rationale>

## Recommendation
Recommendation: <action> because <one-line reason citing the most critical accepted finding>
```

## Verdict Logic

- **PASS** — no high-severity findings
- **CONTESTED** — high-severity findings but reviewers disagree on them
- **REJECT** — high-severity findings with reviewer consensus

## Does the verdict still apply?

A verdict describes a patch, not a branch. A rebase or base retarget rewrites every SHA
without touching a single check, so a green head is not proof the reviewed code is
unchanged. Recompute the base-to-head patch-id and compare it with the **Reviewed** line:
unchanged means the code verdict stands (re-run CI at the new head, not the review);
changed means re-review what moved. Matching commit messages, or a green check from an
older SHA, are not substitutes for the comparison.
