---
name: handoff
description: Pause work into a resumable handoff note, or pick up a previous session's note and continue. Notes live at .handoff/<branch-slug>.md, so pickup needs no path.
argument-hint: "pause: what will the next session focus on? | pickup: leave empty to resume"
disable-model-invocation: true
---

# Handoff

Two modes; infer which from context. A fresh session finding an existing note for the current branch is **pickup**. An in-flight session is **pause**.

## The Convention

Notes live at `.handoff/<branch-slug>.md` in the repo root, where `<branch-slug>` is the current branch name with `/` replaced by `-` (`feature/auth` → `feature-auth.md`). The location is always derived from the branch, never asked for or invented — that is what lets a future session find the note without being told a path.

`.handoff/` must stay out of git: if it isn't already ignored, append `.handoff/` to `.git/info/exclude` (local-only; don't churn the tracked `.gitignore`).

## Pause

1. **Stop at a safe boundary.** Finish or back out the current atomic step — never stop mid-edit with the code broken.
2. **Write the note** to `.handoff/<branch-slug>.md`:
   - **Intent** — what this work is trying to achieve
   - **In-flight step** — where exactly work stopped
   - **Verified so far** — what's proven to work, and how
   - **Next actions** — ordered and concrete
   - **Key files and gotchas**
   - **Suggested skills** the next session should invoke
3. **Don't duplicate other artifacts** (plans, PRs, ADRs, commits, diffs) — reference them by path or URL.
4. **Redact sensitive information** — API keys, passwords, PII.
5. If the user passed arguments, treat them as what the next session will focus on and tailor the note accordingly.

Don't commit anything as part of the handoff — the note lives outside git, and the worktree carries the in-flight changes.

## Pickup

1. **Find the note** at `.handoff/<branch-slug>.md` for the current branch. If absent, list `.handoff/*.md` and ask which to resume.
2. **Reconstruct state** from the note plus `git log` and `git diff` — establish what's done vs pending.
3. **Verify inherited claims against the real artifacts** (`docs/principles/prove-it-works.md`) — the note is a self-report; trust code, tests, and diffs over it. Don't redo work that verifies as done.
4. **Retire the note** when the work completes — delete it; a future pause on the same branch overwrites it.
