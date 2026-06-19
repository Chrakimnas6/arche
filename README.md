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

## Structure

```
.
├── AGENTS.md                 # Project instructions (single source of truth)
├── .agents/
│   └── skills/               # AI agent skills
│       ├── grill-me/         # Relentless design questioning
│       ├── plan/             # Systematic implementation planning
│       ├── tdd/              # Test-driven development
│       ├── review/           # Pre-landing PR review
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
| **tdd** | "use TDD", "red-green-refactor" | Enforces test-driven development with iron law discipline |
| **review** | "review this PR", "check my diff" | Two-pass code review with scope drift detection |
| **adversarial-review** | "adversarial review" | Deep multi-lens review via Codex (Architect/Skeptic/Minimalist lenses) |
| **investigate** | "debug this", "why is this broken" | 4-phase root cause debugging (no fixes without root cause) |
| **hillclimb** | "optimize this metric", "hillclimb the latency" | Keep-or-revert optimization loop toward a target metric |
| **reflect** | "reflect", "what did we learn" | Captures session learnings back into AGENTS.md, skills, and docs |
| **handoff** | `/handoff` (manual only) | Compacts the session into a handoff doc (OS temp dir) for a fresh agent to continue |
| **teach** | `/teach` (manual only) | Multi-session guided learning — turns a dir into a teaching workspace (mission, curated resources, HTML lessons) |
| **resolving-merge-conflicts** | "resolve merge conflict", mid-merge/rebase | Resolves an in-progress conflict by recovering each side's intent, then runs the project's checks |
| **writing-great-skills** | `/writing-great-skills` (manual only) | Rubric for writing & auditing skills — invocation, info hierarchy, leading words, failure modes |

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
