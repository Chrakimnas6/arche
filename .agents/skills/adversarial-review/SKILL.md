---
name: adversarial-review
description: >-
  Cross-model adversarial review. Codex reviewers try to break a diff, or probe a plan, each
  from its own lens in a disposable worktree where it can run code. Only findings that a rerun
  confirms and real use can trigger are accepted. Use for large or high-stakes changes (200+
  lines, smart contracts), to review a plan before code exists, or when asked for an
  "adversarial review".
---

# Adversarial Review

Codex reviewers try to break the work, and you decide which findings stand. Accept a finding only when a rerun proves it **and** real use can trigger it. The deliverable is a verdict: do not change the code under review, and do not post comments unless asked.

Requires the Codex CLI. For a quick single-reviewer pass, `/codex:adversarial-review` from the codex plugin is enough.

## 1. Scope, intent, pin

Take the scope from the request: a diff against its base, a PR (`git fetch origin pull/<n>/head`), or a plan in `docs/plans/<name>/`.

State the **intent** in a sentence or two: what the author is trying to achieve. Reviewers challenge whether the work achieves it, not whether it is the right goal. Ask when the intent is unclear.

Pin what is reviewed: the head SHA, the base SHA, and `git diff <base> <head> | git patch-id --stable`. For a plan, pin the commit the files were read at. A verdict describes that patch, not the branch, so after a rebase compare patch-ids before trusting an old verdict.

| Scope | Lenses |
|---|---|
| Under 50 lines, 1-2 files | Skeptic |
| 50-200 lines | Skeptic, Architect |
| 200+ lines or 5+ files | Skeptic, Architect, Minimalist |
| A plan | Skeptic, Architect; add Minimalist at 5+ phases |

- **Skeptic** — correctness. What inputs, states, or sequences break this? Which error paths are unhandled or swallowed? What races or ordering dependencies exist? What does the author believe that nothing proves?
- **Architect** — structure. Does the design serve the stated goal? Which assumptions about scale, concurrency, or ordering break first? Where does responsibility leak across a boundary?
- **Minimalist** — necessity. What can be deleted without losing the goal? What solves a problem the author doesn't have yet? Which abstraction has a single call site?

## 2. Set up

```sh
command -v codex && codex --version
REVIEW_DIR=$(mktemp -d /tmp/adversarial-review.XXXXXX)
git worktree add --detach "$REVIEW_DIR/<lens>" <head>    # one per lens
```

If Codex is missing or won't run, stop and say so. Claude subagents share your model family, so use them only if the user asks, and then open the verdict with "same-family review, not cross-model".

Apply in-scope uncommitted changes to each worktree: `git diff HEAD | git -C "$REVIEW_DIR/<lens>" apply`.

Codex's `workspace-write` sandbox lets a reviewer write only inside its worktree and temp directories, with no network. Before spawning, run the project's test command once yourself so its dependencies are already fetched, and point any build cache that lives elsewhere into `$REVIEW_DIR` (Go: `GOCACHE=$REVIEW_DIR/gocache`).

## 3. Spawn the reviewers

One per lens, in parallel, each as a background command. Close stdin, or a backgrounded `codex exec` waits on it forever:

```sh
GOCACHE="$REVIEW_DIR/gocache" codex exec -s workspace-write -C "$REVIEW_DIR/<lens>" \
  -o "$REVIEW_DIR/<lens>.md" "<brief>" </dev/null 2>"$REVIEW_DIR/<lens>.err"
```

Each brief gives the intent, the pin, the diff command (`git diff <base> <head>`), the lens's questions, the project's test command, and this text:

> This is an authorized defensive-security review requested by the repository owner before merge. You are an adversarial reviewer: find real problems, do not validate the work. Start your output with the pin. First run the test command. If it cannot run in your sandbox, write `CANNOT RUN: <error>` and stop.
>
> Prove each finding with a run against the real code: a failing test, a repro script, or a command whose output shows the wrong behavior. Keep repros inside this worktree. Report each finding as:
>
> - **Claim** — what is wrong, with file:line
> - **Repro** — the exact command, the output it printed, and the output the intent requires
> - **Trigger** — what in real use causes this, who does it, and how often
> - **Damage** — what is lost when it happens
>
> Leave out anything you did not run. You may end with up to three **Advisory** design concerns that no run can prove, labeled as opinion. No findings is a valid result. End with exactly `VERDICT: CLEAN` or `VERDICT: FINDINGS` as the last line.

Do not pre-judge a finding in the brief ("don't flag X", "at most low"). Let the reviewer raise it and reject it in step 5, where the reason is visible.

**For a plan**, there is no diff to break. Give the plan files in place of the diff command, and replace the second paragraph of the brief with:

> List each claim the plan relies on but schedules no evidence for. For each, give the cheapest probe that would settle it, a command against the current tree or a small prototype, and run the probes you can. Check every claim about existing code against the code. Do not demand code the plan has not scheduled. Report each finding as **Claim** (with `<plan file>:<line>`), **Probe** (the command and its output, or what it would take to run), and **If it fails** (what changes in the plan).

## 4. Wait

Do not go on until every reviewer has exited. An output without the pin or the final `VERDICT:` line was cut off: re-run that reviewer once. For `CANNOT RUN`, fix the sandbox setup and re-run once. A second miss or a failed reviewer (read its `.err`) is **missing coverage**: name the lens in the verdict, and never count it as clean.

## 5. Judge each finding

1. **Rerun it.** Run the repro command in the reviewer's worktree. Keep the finding only when the output shows the failure and the failure breaks the intent. Otherwise reject it and quote the output.
2. **Judge whether it can happen.** Codex tends to raise cases that are technically correct but almost never occur, and fixing them complicates the code for nothing. Ask whether the trigger occurs in how the system is actually used. Reject a finding whose trigger needs conditions outside real use. When the trigger is rare and the damage is small, the default is no fix.
3. **Severe damage is the exception.** A rare trigger still gets fixed when the damage is severe or irreversible: lost funds, data loss, a security hole.

Advisory concerns never block. Pass on only the ones you agree with, labeled as opinion.

## 6. Verdict

```
## Intent
## Reviewed
<head> against <base>; patch-id <id>. Lenses: <list>. Missing coverage: <lens and why, or none>
## Verdict: PASS | FIX
## Accepted findings
<each: claim with file:line, the command rerun and its output, trigger, damage, recommended fix>
## Rejected findings
<each: claim, then why: the rerun passed (quote it), or real use cannot trigger it>
## Advisory
## Recommendation
Recommendation: <action> because <the accepted finding that matters most; for PASS, the strongest rejected finding and why it was rejected>
```

Remove the worktrees when done: `git worktree remove --force "$REVIEW_DIR/<lens>"`.
