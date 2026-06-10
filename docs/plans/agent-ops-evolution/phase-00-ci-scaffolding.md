# Phase 0 — CI scaffolding: registration can't drift

← [Overview](./overview.md)

## Goal

Make principle-registration drift a **CI failure**, not a prose reminder, *before* any new principle is added. This is the scaffold Phase 3 stands on. It exists because the v1 draft cited CI enforcement that doesn't exist: `validate-setup.sh` only iterates names already in `EXPECTED_PRINCIPLES` (a one-way check), so a new principle file omitted from that list passes green — exactly the "15 vs 16" class the last cleanup fixed by hand.

This phase honors `encode-lessons-in-structure`: the lesson ("counts and lists drift") becomes a mechanism, and the un-mechanizable part (a hardcoded number) is deleted rather than guarded.

## Changes

- **`tests/validate-setup.sh`** (Principles section, ~line 191): add a **reverse set-equality** check — every `docs/principles/*.md` file except `index.md` must appear in `EXPECTED_PRINCIPLES`, and vice-versa. Today only the forward direction (expected → exists) runs. Also assert every expected principle is linked from `index.md` (the forward index check already exists; keep it).
- **`README.md`**: remove the hardcoded principle **count** in both the structure-diagram comment (line 44) and the "Principles" section (line 76). Replace "16 engineering principles in `docs/principles/`" with a countless phrasing ("Engineering principles in `docs/principles/`, grouped as:"). Keep the category list. Nothing to drift, nothing to check.

## Key shapes

- No data structures. The set-equality check is a shell comparison of two sorted lists (files on disk vs `EXPECTED_PRINCIPLES` tokens).

## Verification

**Static:**
- `bash tests/validate-setup.sh` green on the current tree (the new check must pass for today's 16 principles).
- `shellcheck tests/validate-setup.sh` clean.

**Runtime (prove the guard actually guards — don't trust "it ran"):**
- Temporarily add a throwaway `docs/principles/_zzz.md` *without* touching `EXPECTED_PRINCIPLES` → confirm `validate-setup.sh` now **fails** (it would have passed before this phase). Remove the file; confirm green again. This is the test that the reverse-check is real, per `prove-it-works`.
- `grep -c '16 engineering' README.md` → 0.
