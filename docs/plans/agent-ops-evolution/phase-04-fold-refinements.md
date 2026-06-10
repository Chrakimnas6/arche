# Phase 4 — Fold three refinements into existing principles

← [Overview](./overview.md)

Independent of all other phases (edits existing files only; no new files, no registration, no count change). Captures the pstack ideas that **substantially overlap** existing principles as refinements rather than new files — honoring `subtract-before-you-add` and the promotion bar's no-overlap criterion.

## Goal

Fold three overlapping ideas in without growing the principle count or duplicating governance.

## Changes

- **`docs/principles/subtract-before-you-add.md`** ← *laziness-protocol*: a tight continuous-discipline corollary — writing code is cheap for an agent, so borrow a maintainer's fatigue: prefer deletion, minimize the diff, question new signal-threading through types/pipelines. Frame as the runtime complement to the existing "subtract first" sequencing.
- **`docs/principles/module-depth.md`** ← *minimize-reader-load*: quantify reader cost by **layers-to-trace and state-to-hold**, collapse one-caller wrappers, shrink mutable scope. **Do not** import pstack's "trace more than 3 files → flatten" rule — it measures physical file count, which contradicts module-depth's core claim that depth is *interface burden*, not file count. Use the interface/layers framing instead.
- **`docs/principles/prove-it-works.md`** ← *sequence-verifiable-units* (execution half): in a sweep/migration, verify each unit before starting the next; never batch-then-verify-once. This is the one genuinely new bit of the dropped principle.
- **`docs/principles/foundational-thinking.md`** ← *sequence-verifiable-units* (delivery half): extend the existing commit-sequencing bullets (lines ~35–39 already cover small, single-purpose, reviewable commits) with the red→green ordering idea — order the stack so the sequence proves itself to a reviewer (failing test first, then fix).

## Notes

- No standalone `sequence-verifiable-units`, `laziness-protocol`, or `minimize-reader-load` files. The review confirmed each overlaps an existing principle; folding is the correct call.
- Keep each fold to a tight paragraph or a few bullets. If a fold wants more than ~6 lines, that's a signal it might deserve its own file after all — stop and flag rather than padding the host.
- If a host principle's "Apply when" trigger (added in Phase 1) no longer covers the folded content, update the trigger and its `index.md` entry to match.

## Verification

**Static:** `bash tests/validate-setup.sh` green (no structural change — same 16 + Phase 3's additions; all files still parse and stay index-referenced). lychee link check.

**Runtime:** Manual read — each fold reads as part of the host principle, not a bolted-on second principle; `module-depth` contains no file-count threshold; the host's thesis + trigger still accurately cover the combined content.
