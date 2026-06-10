# Phase 1 — Selective-read mechanism + global-instruction sync

← [Overview](./overview.md)

## Goal

Stop paying ~9–10k tokens to read all 16 principles on every design/implementation task. Read a small **always-read baseline** plus only the principles whose **trigger** matches the task. Independent of all other phases and the highest-value change here.

This phase is only effective if the *instruction to read everything* is changed wherever it lives — and it lives in three places, two of them outside this repo. v1 treated that as a footnote, which left the fix inert. Here it is an explicit exit criterion.

## Changes

- **`docs/principles/index.md`**: (a) add an **"Always read"** section listing the universal baseline — recommend `prove-it-works` and `surgical-changes` (verify everything; stay in scope when editing). (b) give every other entry an **"Apply when…"** trigger appended to its existing one-line summary. (c) add a compact **routing matrix** mapping common task types to required principles, including high-risk types so governance isn't silently dropped — e.g. *security-sensitive / trust-boundary change* → `threat-modeling` + `stop-on-ambiguity`; *concurrency* → `serialize-shared-state-mutations`; *refactor* → `subtract-before-you-add` + `module-depth`; *debugging* → `fix-root-causes`. (d) a one-line protocol: read the baseline always, then the matches; read all only when genuinely unsure.
- **`.agents/skills/plan/SKILL.md`** (Step 1): replace "Follow every link and read each linked principle file" with the selective protocol (baseline + matched triggers), keeping "always read fresh, never from memory."
- **`global/CLAUDE.md`** (tracked template): update its "Follow every link and read each principle file" line to the selective protocol.

## Exit criteria (not optional — the fix is inert without these)

- **`~/.claude/CLAUDE.md`** and **`~/.codex/AGENTS.md`** both currently say "Follow every link and read each principle file" and both are higher-precedence than repo files. These are owner-edited (outside the repo), so the phase is not "done" until the owner has updated both. The plan must surface this explicitly and the implementer must confirm it, not bury it.

## Key shapes

- Index entry: `[Name](./file.md) — <what>. **Apply when** <trigger>.`
- Routing matrix: a small table, `task type → required principles` (beyond the baseline).

## Verification

**Static:** `bash tests/validate-setup.sh` green (its index substring checks must still match each principle name after triggers are appended); lychee resolves every `index.md` link.

**Runtime (test false-negatives, not just over-selection):**
- Build a fixed routing table for ~6 task types incl. two high-risk ones (a smart-contract storage change, an auth change). For each, confirm the matrix + baseline pulls the principles a senior engineer would demand — specifically that the security tasks pull `threat-modeling`. A task type that drops a principle it should require is a failing case, not a pass.
- Confirm a typical task selects ≤ ~4 principles (baseline + matches); if common tasks still pull half the corpus, the triggers are too loose.
