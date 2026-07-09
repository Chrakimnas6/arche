# Arché (ἀρχή)

My personal setup for working with AI coding agents — engineering principles, a handful of skills, and a self-updating upstream monitor. Built around Claude Code (with Codex for cross-model review); the principles and most skills are portable. This is not a polished template — it's my working setup, shared so you can steal whatever's useful.

*The first principle — a foundation that exists to be superseded.*

## Using This

This is my setup, not a one-command template. Take what's useful:

- **Principles** (`docs/principles/`) and **skills** (`.agents/skills/`) are the most portable — copy the individual files you want straight into your own project.
- If you want the whole layout, copy it with a tool that preserves symlinks. The `.claude/` entries are symlinks into `.agents/`, and a plain `cp -r` flattens them into duplicate files (especially on macOS):

```bash
# rsync -a (or tar) preserves the .claude -> .agents symlinks; plain `cp -r` would flatten them
rsync -a AGENTS.md .agents .claude docs /path/to/your/project/
```

Then fill in the project-specific sections in `AGENTS.md` (build/test commands, conventions).

Alternatively, make everything available in *every* project on your machine instead of copying per project: `bash scripts/sync-global.sh` compares `~/.claude/` against this repo, symlinks any skill or agent the global config is missing, prunes links left dangling by renamed or removed skills, and reports global-only entries (personal skills with no arche counterpart — candidates to adopt) plus any `CLAUDE.md` drift. Re-run it after adding a skill or agent; it's idempotent and never touches entries that don't point into this repo. `--check` runs the same comparison without changing anything and exits non-zero when out of sync.

## Structure

```
.
├── AGENTS.md                 # Project instructions (single source of truth)
├── .agents/
│   ├── agents/               # Subagent definitions
│   │   └── implementer.md    # Implementation worker (plan big, execute small)
│   └── skills/               # AI agent skills
│       ├── grill-me/         # Relentless design questioning
│       ├── plan/             # Systematic implementation planning
│       ├── execute-plan/     # Phase-by-phase plan execution
│       ├── tdd/              # Test-driven development
│       ├── pre-landing-review/ # Pre-landing PR review
│       ├── adversarial-review/ # Cross-model adversarial review
│       ├── investigate/      # Root cause debugging
│       ├── hillclimb/        # Keep-or-revert metric optimization
│       ├── reflect/          # Post-task learning capture
│       ├── handoff/          # Session handoff doc (for a fresh agent)
│       ├── teach/            # Multi-session guided learning workspace
│       ├── resolving-merge-conflicts/ # Resolve merge/rebase conflicts
│       └── writing-great-skills/ # Rubric for authoring & auditing skills
├── .claude/
│   ├── CLAUDE.md             # -> ../AGENTS.md (symlink)
│   ├── skills                # -> ../.agents/skills (symlink)
│   └── settings.json         # Claude Code settings (currently empty)
├── .github/
│   ├── upstream-monitor.md   # Scheduled agent prompt (weekly upstream adoption)
│   ├── upstream-shas.json    # Last-seen SHAs for monitored upstream repos
│   └── workflows/ci.yml      # validate-setup + shellcheck + markdown-links
├── docs/
│   ├── principles/           # Engineering principles
│   ├── applications/         # Language overlays (Go, smart contracts)
│   ├── plans/                # Implementation plans (skill output)
│   └── design/               # Design documents
├── scripts/
│   └── sync-global.sh        # Compare ~/.claude with this repo; link what's missing
├── tests/
│   ├── validate-setup.sh     # Structural invariants (runs in CI)
│   └── test-adversarial-review.sh # Manual smoke test (requires codex CLI)
└── global/
    └── CLAUDE.md             # My ~/.claude/CLAUDE.md (personal — edit before reuse)
```

### Why This Structure?

- **`.agents/`** is the canonical source for all agent configuration
- **`.claude/`** contains symlinks back to `.agents/`, so Claude Code discovers everything automatically
- **`AGENTS.md`** at the root is read by both Claude Code (via symlink) and Codex (natively)
- **`docs/`** provides persistent context that both humans and agents reference

## Skills

| Skill | Trigger | What It Does |
|-------|---------|-------------|
| **grill-me** | "grill me", "stress-test this plan" | Interviews you relentlessly about every design decision |
| **plan** | "plan this", "break this down" | Creates phased implementation plans in `docs/plans/` |
| **execute-plan** | "implement the plan", "execute the plan" | Implements a plan phase by phase; each phase's verification gates the next |
| **tdd** | "use TDD", "red-green-refactor" | Enforces test-driven development with iron law discipline |
| **pre-landing-review** | "review my changes", "check my diff" | Two-pass code review with scope drift detection |
| **adversarial-review** | "adversarial review" | Deep multi-lens review via Codex (Architect/Skeptic/Minimalist lenses) |
| **investigate** | "debug this", "why is this broken" | 4-phase root cause debugging (no fixes without root cause) |
| **hillclimb** | "optimize this metric", "hillclimb the latency" | Keep-or-revert optimization loop toward a target metric |
| **reflect** | "reflect", "what did we learn" | Captures session learnings back into AGENTS.md, skills, and docs |
| **handoff** | `/handoff` (manual only) | Pause/pickup notes at `.handoff/<branch>.md` (git-ignored) so a fresh session resumes without being told a path |
| **teach** | `/teach` (manual only) | Multi-session guided learning — turns a dir into a teaching workspace (mission, curated resources, HTML lessons) |
| **resolving-merge-conflicts** | "resolve merge conflict", mid-merge/rebase | Resolves an in-progress conflict by recovering each side's intent, then runs the project's checks |
| **writing-great-skills** | `/writing-great-skills` (manual only) | Rubric for writing & auditing skills — invocation, info hierarchy, leading words, failure modes |

## Agents

| Agent | Used by | What It Does |
|-------|---------|-------------|
| **implementer** | `execute-plan` | Cheap-model implementation worker (defaults to Sonnet): takes one phase brief, implements and verifies it, reports back with artifacts. The orchestrating session re-runs verification and gates the next phase — design judgment stays in the main loop. |

## Workflow

For non-trivial work the skills chain into a pipeline, each stage handing the next a durable artifact so the chain survives session boundaries:

1. `grill-me` — stress-test the requirement → decision record in `docs/design/`
2. `plan` — decision record + codebase exploration → phased plan in `docs/plans/<name>/`
3. `adversarial-review` (plan mode) — challenge the design before any code exists
4. `execute-plan` — implement phase by phase; each phase's verification gates the next
5. `pre-landing-review` — add `adversarial-review` for large or high-stakes diffs
6. `reflect` — route learnings back into the setup

The chain is encoded in `AGENTS.md`, so any session can pick it up mid-stream. Stages are skipped deliberately, not by omission.

## Principles

Engineering principles in `docs/principles/`, grouped as:

- **Core**: foundational thinking, redesign from first principles, subtract before you add, experience first, exhaust the design space
- **Architecture**: module depth, boundary discipline, idempotent operations, serialize shared state, threat modeling, observability
- **Verification**: prove it works, fix root causes, stop on ambiguity, surgical changes, build the lever
- **Delegation**: guard the context window, never block on the human
- **Meta**: encode lessons in structure

Language-specific applications (Go, smart contracts) live in `docs/applications/`, kept separate so the principles stay paradigm-agnostic.

## Global Config

`global/CLAUDE.md` is my personal `~/.claude/CLAUDE.md` — it carries my name, GitHub handle, and machine-specific tooling. Don't copy it verbatim; read it as a reference for shaping your own.

## Recommended Plugin

Install the [Codex plugin for Claude Code](https://github.com/openai/codex-plugin-cc) for seamless Codex integration:

```bash
/plugin marketplace add openai/codex-plugin-cc
/plugin install codex@openai-codex
/reload-plugins
/codex:setup
```

This gives you `/codex:review`, `/codex:adversarial-review`, and `/codex:rescue` commands. The `adversarial-review` skill in this setup provides deeper multi-lens analysis using `codex exec` directly — the plugin is recommended but not required for the skill. Both paths require the Codex CLI (`npm install -g @openai/codex`) and authentication (`codex login`).

## Self-Updating

A weekly Claude Code scheduled agent monitors upstream repos for changes in the paths we care about. When relevant updates are found, it reads the actual source files, implements adaptations directly, and opens or updates a rolling adoption PR. Managed via `/schedule` in Claude Code. Full routine prompt lives at [`.github/upstream-monitor.md`](./.github/upstream-monitor.md).

Upstream sources: [cursor/plugins](https://github.com/cursor/plugins/tree/main/pstack) (pstack — poteto's successor to noodle), [garrytan/gstack](https://github.com/garrytan/gstack), [mattpocock/skills](https://github.com/mattpocock/skills), [obra/superpowers](https://github.com/obra/superpowers).

## Customization

This is a starting point. Per-project, you should:

1. Fill in `AGENTS.md` with your build/test/lint commands and project conventions
2. Add or remove skills as needed (use the `skill-creator` plugin)
3. Add project-specific principles to `docs/principles/`
4. Let skills and docs evolve as you work — the setup is designed to self-improve
