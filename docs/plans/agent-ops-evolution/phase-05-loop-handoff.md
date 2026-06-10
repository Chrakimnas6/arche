# Phase 5 — Loop-engineering handoff convention (deferrable)

← [Overview](./overview.md)

Independent and **deferrable** — the largest new surface. Ship Phases 0–4 first; pick this up only if you actually run multi-session, `/loop`, or scheduled/autonomous work. Closes arche's real loop-engineering gap: cross-session state ("models forget between runs").

## Goal

A lightweight, Claude-Code-native pause/resume convention so a cold agent can take over in-flight work without redoing it — with the safety holes the review found designed out from the start.

## Changes (a new `handoff` skill)

- **New `.agents/skills/handoff/SKILL.md`** covering two modes:
  - **Pause** ("pause safely", "going offline", before context compaction): stop at a safe boundary (finish or back out the current atomic step — never stop mid-edit broken); write the resume note to the **one canonical durable location** (see below). Commit only the agent's *own* in-flight work, and only after the ownership check below — **no blanket `git add -A` + `wip:` sweep** (it can absorb unrelated user edits or secrets).
  - **Pickup** ("resume", "take over", "continue from <branch>"): discover the note by convention (below), read the prior trail, reconstruct state from `git log`/diff, diff done-vs-pending, and **verify inherited claims against the real artifact** (`prove-it-works`) rather than trusting a prior self-report — don't redo completed work.
- **Registration:** add `handoff` to `EXPECTED_SKILLS` in `tests/validate-setup.sh` and to the README skills table.

## Hardening (each closes a specific review finding)

- **Discoverable, durable location:** resume notes live at `.handoff/<branch-slug>.md`, with `.handoff/` git-ignored. Pickup derives the path from the current branch — no out-of-band pointer, not `/tmp` (which doesn't survive a reboot). One location, not two.
- **Ownership-safe commit:** before any commit, branch first if on the default branch; stage only paths the agent itself modified this session; if the worktree has unrelated dirty edits, **surface them and stop**, don't sweep them into the handoff (`surgical-changes`).
- **One artifact:** no optional decision-trail TSV alongside the resume note — that was a second/third source of truth. The resume note is the single handoff artifact.

## Key shapes

- **Resume note** (`.handoff/<branch-slug>.md`): intent · in-flight step · what's verified · next actions · key files · gotchas.

## Out of scope (confirmed, no reviewer challenge)

No ralph-loop-style runner (Claude Code's `/loop`, `ScheduleWakeup`, and scheduled tasks already loop); no `poteto-mode` router; no `arena`/`interrogate` (we have `adversarial-review` — at most graft its model-diversity framing as a one-paragraph note, only if cheap).

## Verification

**Static:** `bash tests/validate-setup.sh` green (new skill present, valid `name`/`description` frontmatter, in `EXPECTED_SKILLS` and README table); lychee link check.

**Runtime (the real test — does a cold agent resume cleanly):**
- On a throwaway branch with a deliberately *dirty* unrelated edit present, invoke Pause → confirm it commits only its own work (the unrelated edit is surfaced and left alone, not swept), writes `.handoff/<branch>.md`, and leaves the tree non-broken.
- From a fresh context given only "resume," invoke Pickup → confirm it finds the note from the branch name, reconstructs state, and does **not** redo the completed step.
