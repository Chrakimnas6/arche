# Arché (ἀρχή)

My personal setup for working with AI coding agents: a few engineering principles, a handful of skills, and a weekly upstream report. It is built around Claude Code, with Codex for cross-model review. This is my working setup, not a template, shared so you can take whatever is useful.

*The first principle — a foundation that exists to be superseded.* I trim it as models improve, and a line stays only if it still changes what the agent does.

## What's here

- `.agents/skills/` — the skills. Each `SKILL.md` says what it does and when it triggers.
- `.agents/agents/` — two Claude Code subagents: `implementer` runs one plan phase, and `comment-reviewer` removes comments the code doesn't need.
- `docs/principles/` — engineering principles. The `plan` skill reads them all; other skills cite the ones they use.
- `AGENTS.md` — project instructions, including the workflow that chains the skills: grill, plan, review the plan, execute, review the code, reflect.
- `global/CLAUDE.md` — my `~/.claude/CLAUDE.md`. It has my name and machine-specific tooling, so read it as a reference, not something to copy.
- `.github/upstream-monitor.md` — the prompt for a weekly scheduled agent that reports what changed in the upstream repos below.

Two layout choices are deliberate. Claude Code doesn't look under `.agents/`, so `.claude/skills` is a symlink to `.agents/skills`. Both Claude Code and Codex read `AGENTS.md`, but a `CLAUDE.md` beside it would make Claude Code skip it.

## Using it

Copy the individual skill or principle files you want. To copy the whole layout, use a tool that keeps symlinks, because a plain `cp -r` flattens `.claude/skills` into duplicate files:

```bash
rsync -a AGENTS.md .agents .claude docs /path/to/your/project/
```

To make the skills available in every project on your machine instead, run the sync script:

```bash
bash scripts/sync-global.sh
```

It symlinks each skill into `~/.claude/skills/`, `~/.agents/skills/` and `~/.codex/skills/`, and each agent into `~/.claude/agents/`. It prunes links left behind by removed skills and never touches entries that don't point into this repo. `--check` reports without changing anything.

The `adversarial-review` skill needs the Codex CLI (`npm install -g @openai/codex`, then `codex login`). The [Codex plugin for Claude Code](https://github.com/openai/codex-plugin-cc) adds `/codex:review` and `/codex:adversarial-review` for quicker single-reviewer passes.

## Upstream sources

Much of this is adapted from other people's work; licenses are in `THIRD-PARTY-NOTICES`.

- [cursor/plugins](https://github.com/cursor/plugins/tree/main/pstack) — pstack, poteto's successor to [noodle](https://github.com/poteto/noodle), where the principles and the adversarial review came from
- [mattpocock/skills](https://github.com/mattpocock/skills)
- [garrytan/gstack](https://github.com/garrytan/gstack) — a few lines in `plan`, `tdd` and `adversarial-review`; no longer tracked
- [dietrichgebert/ponytail](https://github.com/dietrichgebert/ponytail) — the reuse ladder in `subtract-before-you-add`
- [obra/superpowers](https://github.com/obra/superpowers) — a few lines of wording; no longer tracked
