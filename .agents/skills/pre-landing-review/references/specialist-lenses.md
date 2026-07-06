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
