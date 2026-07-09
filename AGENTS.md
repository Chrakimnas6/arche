# Project

<!-- One-line project description. Fill in per project. -->

## Docs

Read `docs/` relevant to your task before acting. Key resources:

- `docs/principles/` — engineering principles governing design and implementation decisions
- `docs/plans/` — implementation plans for features and changes
- `docs/design/` — design documents and architecture decisions

## Workflow

Non-trivial work moves through stages. Each stage hands the next a durable artifact, so the chain survives session boundaries instead of living in anyone's head:

1. **Grill** (`grill-me`) — stress-test the requirement; ends by writing a decision record to `docs/design/`
2. **Plan** (`plan`) — decision record + codebase exploration → phased plan in `docs/plans/<name>/`
3. **Review the plan** (`adversarial-review`, plan mode) — challenge the design before any code exists
4. **Execute** (`execute-plan`) — implement phase by phase, delegating implementation to the `implementer` agent where available; each phase's verification gates the next
5. **Review the code** (`pre-landing-review`; add `adversarial-review` for large or high-stakes diffs)
6. **Reflect** (`reflect`) — route what was learned back into skills, principles, and this file

Stages are skipped deliberately, not by omission — a trivial fix can go straight to implementation, but say so. When picking up mid-chain, read the upstream artifacts first.

## Commands

- **Validate setup:** `bash tests/validate-setup.sh` (arche's own check; replace with build/test/lint commands per project)
<!-- Fill in per project. Examples: -->
<!-- - **Build:** `go build ./...` -->
<!-- - **Test:** `go test ./...` -->
<!-- - **Lint:** `golangci-lint run` -->
<!-- Beyond commands: encode how to launch, drive, and observe the running app as a project verify skill (.agents/skills/verify/), so agents can prove changes work end-to-end, not just that tests pass. -->

## Conventions

<!-- Fill in per project. Only include things the agent cannot infer from the code. Examples: -->
<!-- - Error messages describe failure state, not expectations -->
<!-- - All public APIs validated at boundary; trust internal code -->
