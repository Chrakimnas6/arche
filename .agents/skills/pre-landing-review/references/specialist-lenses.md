# Specialist Lens Checklists

Loaded from Step 4 of the pre-landing-review skill. Apply only the lenses whose signal matched the diff.

## Security Lens

When the diff touches auth/permissions/access control code:

- Input validation at trust boundaries — are all external inputs validated before use?
- Auth/authz bypass — can the new code path be reached without proper authentication?
- Injection vectors beyond SQL — command injection, path traversal, SSRF
- Cryptographic misuse — hardcoded secrets, weak algorithms, improper key management
- Attack surface expansion — does this change expose new endpoints or capabilities?

## Data Safety Lens

When the diff touches migrations or schema:

- Reversibility — can this migration be rolled back without data loss?
- Data loss risk — dropping columns, narrowing types, adding NOT NULL without defaults
- Lock duration — will ALTER TABLE lock production tables for an unacceptable duration?
- Migration ordering — does this migration depend on another that may not have run?

## API Contract Lens

When the diff touches API routes or contracts:

- Breaking changes — removed fields, type changes, new required parameters
- Versioning consistency — does this follow the project's API versioning strategy?
- Error response standardization — do new error cases follow existing patterns?
- Backward compatibility — will existing clients break?

## Performance Lens

When the diff touches queries or data-fetching code:

- N+1 queries — loops that issue a query per iteration
- Missing indexes — new queries on columns without indexes
- Algorithmic complexity — O(n²) patterns, unbounded iterations
- Large payloads — endpoints returning unbounded result sets without pagination

## Simplification Lens

When the diff adds substantial new structure (roughly 100+ changed lines of application code). Hunts unrequested *structure* only — findings are INFORMATIONAL and advisory. Coverage gaps are out of scope: Step 5 owns those. Simplification and test-coverage findings are orthogonal, not contradictory — coverage pushes tests UP, simplification pushes unrequested structure DOWN; the same diff can legitimately receive both.

Tag each finding with exactly one category:

- `delete` — dead code, unused flexibility, speculative feature. Replacement: nothing.
- `stdlib` — hand-rolled thing the standard library ships. Name the function.
- `native` — dependency or code doing what the platform already does (DB constraint over app code, CSS over JS). Name the feature.
- `speculative` — abstraction with one implementation, config nobody sets, layer with one caller.
- `shrink` — same logic, fewer lines; only when the reduction is ≥5 lines. Show the shorter form.

**Finding style: location + what to cut + what replaces it.** "This validator might be more complex than necessary" is not a finding; "`lib/email.go:12` — 27-line validator, `stdlib`: a contains-`@` check covers it; real validation is the confirmation mail" is.

Shared-helper extraction proposals follow the extraction rule in Step 3 Pass 2 (two real callers, existing helper checked first); do not duplicate them here or turn a structural preference into a defect.

Never flag for deletion: tests, error paths, edge-case branches, input validation, security measures, accessibility. A single smoke test is the completeness minimum, not bloat. Skip harmless redundancy that aids readability, consistency-only changes, and anything the diff itself already addresses. These findings map to `docs/principles/subtract-before-you-add.md` — cite the reuse-ladder rung the fix lands on.
