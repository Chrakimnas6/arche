# Agent-Ops Evolution — Overview (v2, post-review)

**Mode:** Feature (incremental changes to the existing arche repo).

**Status:** Plan only — nothing implemented. This is **v2**: revised after a Fable self-review and a 3-lens Codex adversarial review (Skeptic/Architect/Minimalist). The v1 draft's defects and how v2 fixes them are listed in [Changelog](#changelog-v1--v2) below.

## Context

`poteto/noodle` — arche's principle ancestor — has been quiet since 2026-03-19. Its living successor is `pstack` (in `cursor/plugins`), shipped from daily use at Cursor. pstack and Addy Osmani's "loop engineering" post point at the same shift: running agents hard produced a category of *agent-operating* principles (guard the context window, never block on the human, build the lever) and an operational need — **cross-session state** — that arche, a single-session-quality setup, does not address.

This plan adopts the high-value, minimal subset and skips pstack's heavier machinery. Two policies are decided by the owner: **(1)** relax the principle-promotion citation bar so agent-era principles can qualify; **(2)** adopt `never-block-on-the-human` in reconciled form.

## Scope

**In:** a selective-read mechanism for principles (index triggers + a small always-read baseline); three new agent-era principles (`guard-the-context-window`, `build-the-lever` [narrowed], `never-block-on-the-human` [reconciled]); folding three overlapping pstack ideas into existing principles; **re-pointing** the monitor noodle → pstack and relaxing its promotion bar; CI scaffolding so principle registration can't silently drift; and a deferrable cross-session handoff convention.

**Out (considered, skipped — drew no reviewer challenge):** the full `poteto-mode` router + 15 playbooks; `arena`/`interrogate` as separate skills (we have `adversarial-review`); `unslop`; `automate-me`; `why`'s 7-MCP fan-out; `type-system-discipline` as a top-level principle (belongs in `go.md`/`smart-contracts.md`). A standalone `sequence-verifiable-units` principle was **dropped** (folded — see Changelog). A per-file trigger backfill was **dropped** (index-only — see Changelog).

## Dependency graph (read before picking a subset)

The v1 "every phase is independently shippable" claim was **false** and is retracted. Real dependencies:

```
Phase 0 (CI scaffold) ─────────────┐
                                    ├──► Phase 3 (add 3 principles)
Phase 2 (monitor + relax bar) ─────┘
Phase 1 (selective read + globals)  ── independent, highest-value
Phase 4 (fold refinements)          ── independent (edits existing files only)
Phase 5 (loop handoff)              ── independent, deferrable
```

- **Phase 3 requires Phase 0 and Phase 2.** The new principles need the relaxed bar (Phase 2) to be admissible, and the CI reverse-check (Phase 0) so an unregistered principle can't pass green.
- **Phases 1, 4, 5 are genuinely independent** of the others and of each other.
- **Recommended first slice:** Phase 1 (the read-cost fix — headline value) + Phase 0 (cheap, unblocks 3) + Phase 2 (point the monitor at the repo that's actually alive). Phase 3 after 0+2. Phase 4 anytime. Phase 5 only if you run multi-session/autonomous work.

## Constraints & alternatives

- **Selective-read mechanism.** Chosen: triggers in `index.md` **only**, plus a small always-read baseline. Rejected: (a) duplicating triggers into every principle file (a second routing authority synced by hand — and literally unexecutable, since 5 files lack the `**Principle:**` marker v1 targeted); (b) full principles-as-skills conversion (16+ skills is machinery a personal setup doesn't need); (c) status quo (read all 16, the cost we're fixing).
- **Always-read baseline vs. pure triggers.** `prove-it-works` ("every task output") and `surgical-changes` ("whenever editing existing code") are near-universal; making them *triggered* would let an agent silently skip governance (e.g. a security migration omitting `threat-modeling`). Chosen: a 2-principle always-read baseline + a routing matrix that names required principles per task type, including high-risk types. Tradeoff: a tiny fixed cost buys back the false-negative safety pure triggers lose.
- **Monitor state shape.** Keep the existing **flat** `repo → SHA`. Rejected: nested `repo → {path → SHA}` — it passes JSON validation but breaks the monitor's Step 2/5, which compare one aggregate SHA per repo. Watched paths stay in the prompt.
- **noodle disposition.** v1 said "re-point" (replace) in Scope but "keep both" in the recommendation — a self-contradiction. v2 resolves it: **remove noodle, add pstack** (true re-point). Rationale: noodle is dormant and the stated intent + minimalist identity favor removal over a permanent low-value watch. (If you'd rather keep it, that's a one-line override — flagged in Phase 2.)
- **Home for agent-era principles.** `docs/principles/` under the relaxed bar (owner's call), in a new **Delegation** category. The `docs/operations/` alternative (separate corpus, exempt from the bar) is the road not taken; revisit only if the agent-ops set grows past ~5.

## Principles applied (citations)

- **Experience First** — the selective-read fix treats the next agent turn's token budget as the product; reading 16 docs to use 2 is a bad consumer experience.
- **Subtract Before You Add** — v2 *cut* a phase and folded two more rather than adding overlapping principles; the no-overlap check drove dropping standalone `sequence-verifiable-units`.
- **Encode Lessons in Structure** — Phase 0 makes principle-registration drift a CI failure instead of a prose reminder, and removes the hardcoded README count entirely (nothing to drift). This is the principle the v1 draft *cited* but *violated* (it relied on a CI check that didn't exist).
- **Foundational Thinking** — the corrected dependency graph sequences scaffold (Phase 0) and policy (Phase 2) before the features that need them.
- **Stop on Ambiguity** — `never-block-on-the-human` is scoped *against* this, not over it: block on design/requirements ambiguity and irreversible actions; proceed on reversible execution.

## Phases

0. [CI scaffolding: registration can't drift](./phase-00-ci-scaffolding.md) — prerequisite for Phase 3.
1. [Selective-read mechanism + global-instruction sync](./phase-01-selective-read-mechanism.md) — headline value, independent.
2. [Monitor: re-point noodle → pstack + relax promotion bar](./phase-02-monitor-repoint-and-relax-bar.md) — prerequisite for Phase 3.
3. [Add three agent-era principles (one PR)](./phase-03-add-principles.md) — needs 0 + 2.
4. [Fold three refinements into existing principles](./phase-04-fold-refinements.md) — independent.
5. [Loop-engineering handoff convention](./phase-05-loop-handoff.md) — deferrable.

## Verification (project-level)

- `bash tests/validate-setup.sh` green (after Phase 0 it also enforces principle set-equality).
- `shellcheck` on touched scripts; lychee `--offline` markdown link check for new cross-references.
- Manual read for prose quality — the principles are read by agents; clarity is the product.

## Changelog (v1 → v2)

Every change below traces to an accepted review finding (Fable self-review + Codex panel):

- **Retracted the false "independently shippable / 3–6 parallel" claim** → added the dependency graph above; Phase 2 now precedes Phase 3. *(H1)*
- **Fixed the monitor JSON shape** → kept flat `repo → SHA`; v1's nested proposal would have broken the monitor. *(H2)*
- **Stopped claiming non-existent CI enforcement** → added Phase 0 (reverse set-equality) and removed the hardcoded README count, instead of relying on prose diligence. *(H3)*
- **Made global-instruction updates a real exit criterion of Phase 1** → there are *two* out-of-repo surfaces (`~/.claude/CLAUDE.md`, `~/.codex/AGENTS.md`) plus the tracked `global/CLAUDE.md`; v1 demoted this to a side-note, leaving the fix inert. *(H4)*
- **Cut the per-file trigger backfill (old Phase 2)** → triggers live only in the index; the backfill was a second source of truth and unexecutable on 5 files. *(M1)*
- **Narrowed `build-the-lever`** → restored the "triviality, not repetition" balance + "reuse existing tools first"; v1 over-broadened it into conflict with subtract-before-you-add. *(M2)*
- **Dropped standalone `sequence-verifiable-units`** → folded its sweep-verify rule into `prove-it-works` and its red→green delivery ordering into `foundational-thinking` (which already sequences commits). *(M3)*
- **Reframed the folded `minimize-reader-load` metric** → "layers/interface burden," not "more than three files," which contradicts `module-depth`. *(M4)*
- **Resolved the noodle re-point contradiction** → remove, don't keep-both. *(M5)*
- **Hardened the handoff** → one canonical git-ignored location with branch-based discovery; scoped staging with ownership checks; no automatic blanket `wip:` commit; dropped the optional decision-trail TSV (one artifact, not three). *(M6)*
- **Added an always-read baseline + routing matrix** → pure triggers could silently drop governance on high-risk tasks. *(M7)*
- **Merged promotion criteria 1 and 5** → relaxing C1 made it duplicate C5; the bar goes from 5 criteria to 4. *(lead-judgment addition)*
- **Documented the phase-sizing exceptions** honestly (atomic registration, the Phase 3 multi-file principle add) rather than claiming compliance with the ≤3-files rule. *(L1)*
