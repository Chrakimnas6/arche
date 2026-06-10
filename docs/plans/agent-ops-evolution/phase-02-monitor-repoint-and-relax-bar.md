# Phase 2 — Monitor: re-point noodle → pstack + relax promotion bar

← [Overview](./overview.md)

## Goal

Point the upstream monitor at the *living* successor (`cursor/plugins` → `pstack/`) instead of the dormant `poteto/noodle`, and relax the principle-promotion bar so agent-era operating principles can qualify. Prerequisite for Phase 3 (its principles can't cite Brooks/Fowler).

## Changes

- **`.github/upstream-shas.json`**: replace the `poteto/noodle` entry with `"cursor/plugins"`. Keep the **flat `repo → SHA`** shape — do **not** introduce a nested `{path → SHA}` object (it passes JSON validation but breaks the monitor's Step 2/5, which reduce all watched paths to one repo-level SHA). The pstack subdir is expressed as a watched *path* in the prompt, not in the JSON.
- **`.github/upstream-monitor.md`**: (a) in "Watched paths per repo," replace the noodle line with `cursor/plugins` → `pstack/skills`, `pstack/agents` (the monorepo subdir; the path-scoped Step 2 already supports this). (b) **Merge promotion criteria 1 and 5** into a single citation/acceptance criterion: *backed by ≥2 authoritative sources OR broad practitioner consensus — agent-era operating principles may cite frontier-lab guidance or widely-adopted implementations (e.g. pstack) instead of canonical books.* Renumber to **4 criteria**. Add a one-paragraph rationale: the original bar was calibrated for timeless design principles and structurally excluded the agent-operating category, which is now load-bearing.
- **`README.md`**: update the "Upstream sources" line — remove noodle, add `cursor/plugins/pstack`.

## Decisions resolved (v1 was self-contradictory here)

- **noodle: removed, not demoted.** This is a true "re-point," consistent with the Scope statement and the minimalist identity. Override only if you have a concrete continuing reason to watch noodle — if so, keep its flat entry and say so in the README; don't leave the plan ambiguous.
- The merged criterion is what makes Phase 3 admissible; if Phase 3 ships first for any reason, its PR must note it depends on this relaxation.

## Key shapes

- `upstream-shas.json`: flat `{ "owner/repo": "<sha>", ... }` — unchanged shape, changed keys.

## Verification

**Static:** `bash tests/validate-setup.sh` green — note its README-vs-`upstream-shas.json` check derives expected repos from the JSON keys, so the README "Upstream sources" line must list `cursor/plugins` after the swap. `upstream-shas.json` valid JSON. `shellcheck` clean if any script changes.

**Runtime:**
- Hit `GET /repos/cursor/plugins/commits?path=pstack&per_page=1` and confirm it returns the latest pstack-touching commit — proves path-scoping resolves a real SHA for a monorepo subdir before relying on it.
- Re-read the merged criterion end-to-end: confirm it would *accept* `guard-the-context-window` (consensus-backed) and still *reject* a single blog-post pattern (bar relaxed, not removed).
