# Vibe Coding Setup

A minimal, model/tool-agnostic template for bootstrapping software projects with AI coding agent support. Works with Claude Code, Codex, and other AI coding tools.

## Quick Start

To use this setup in a new project, copy the following to your project root:

```bash
# Copy the template files (adjust source path as needed)
cp -r AGENTS.md .agents .claude .codex docs /path/to/your/project/
```

Then fill in the project-specific sections in `AGENTS.md` (build commands, conventions, etc.).

## Structure

```
.
├── AGENTS.md                 # Project instructions (single source of truth)
├── .agents/
│   ├── hooks/                # Git/tool hooks
│   │   └── check-careful.sh  # Destructive command guardrail
│   └── skills/               # AI agent skills
│       ├── grill-me/         # Relentless design questioning
│       ├── plan/             # Systematic implementation planning
│       ├── tdd/              # Test-driven development
│       ├── review/           # Pre-landing PR review
│       ├── adversarial-review/ # Cross-model adversarial review
│       ├── investigate/      # Root cause debugging
│       ├── careful/          # Destructive command docs
│       └── reflect/          # Post-task learning capture
├── .claude/
│   ├── CLAUDE.md             # -> ../AGENTS.md (symlink)
│   ├── hooks                 # -> ../.agents/hooks (symlink)
│   ├── skills                # -> ../.agents/skills (symlink)
│   └── settings.json         # Tool hook configuration
├── .codex/
│   └── config.toml           # Codex model config (gpt-5.4, high reasoning)
├── docs/
│   ├── principles/           # 13 engineering principles
│   ├── plans/                # Implementation plans (skill output)
│   └── design/               # Design documents
└── global/
    └── CLAUDE.md             # Global config template for ~/.claude/CLAUDE.md
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
| **adversarial-review** | "adversarial review" | Spawns reviewers on the opposing model for cross-model analysis |
| **investigate** | "debug this", "why is this broken" | 4-phase root cause debugging (no fixes without root cause) |
| **careful** | Always active | Warns before destructive commands (rm -rf, force-push, etc.) |
| **reflect** | "reflect", "what did we learn" | Captures session learnings back into AGENTS.md, skills, and docs |

## Principles

13 engineering principles in `docs/principles/`, covering:

- **Core**: foundational thinking, redesign from first principles, subtract before you add, outcome-oriented execution, experience first, exhaust the design space
- **Architecture**: boundary discipline, idempotent operations, migrate-then-delete, serialize shared state
- **Verification**: prove it works, fix root causes
- **Meta**: encode lessons in structure

## Global Config

Copy `global/CLAUDE.md` to `~/.claude/CLAUDE.md` for your personal global settings, or use it as a starting point.

## Self-Updating

A daily GitHub Action monitors upstream repos for changes and opens PRs with AI-analyzed recommendations when relevant updates are found. See `.github/workflows/upstream-monitor.yml`.

Upstream sources: [poteto/noodle](https://github.com/poteto/noodle), [garrytan/gstack](https://github.com/garrytan/gstack), [mattpocock/skills](https://github.com/mattpocock/skills), [obra/superpowers](https://github.com/obra/superpowers).

## Customization

This is a starting point. Per-project, you should:

1. Fill in `AGENTS.md` with your build/test/lint commands and project conventions
2. Add or remove skills as needed (use the `skill-creator` plugin)
3. Add project-specific principles to `docs/principles/`
4. Let skills and docs evolve as you work — the setup is designed to self-improve
