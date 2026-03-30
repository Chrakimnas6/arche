# Upstream Monitoring Context

This file provides context for the AI analysis step in the upstream monitoring workflow. It describes what this repo contains and how it relates to upstream sources, so the AI can judge whether upstream changes are relevant and recommend specific updates.

## What This Repo Is

A minimal, model/tool-agnostic template for bootstrapping software projects with AI coding agent support. Focused on Go and smart contract development. Contains skills, engineering principles, and hooks adapted from upstream sources.

## Skills and Their Upstream Sources

| Skill | Based On | What It Does | Key Files to Watch Upstream |
|-------|----------|-------------|---------------------------|
| `grill-me` | mattpocock/skills `grill-me/` | Relentless questioning about plans/designs | `grill-me/SKILL.md` |
| `plan` | poteto/noodle `.agents/skills/plan/` | Systematic phased planning (greenfield + feature modes) | `plan/SKILL.md`, `plan/references/templates.md` |
| `tdd` | mattpocock/skills `tdd/` + obra/superpowers `skills/test-driven-development/` | Test-driven development with red-green-refactor | `tdd/SKILL.md`, `tdd/*.md`, `skills/test-driven-development/SKILL.md`, `skills/test-driven-development/testing-anti-patterns.md` |
| `review` | garrytan/gstack `review/` | Pre-landing PR review with scope drift detection | `review/SKILL.md`, `review/SKILL.md.tmpl`, `review/checklist.md` |
| `adversarial-review` | poteto/noodle `.agents/skills/adversarial-review/` | Cross-model adversarial code review | `adversarial-review/SKILL.md`, `adversarial-review/references/*.md` |
| `investigate` | obra/superpowers `skills/systematic-debugging/` | 4-phase root cause debugging | `skills/systematic-debugging/SKILL.md`, `skills/systematic-debugging/*.md` |
| `careful` | garrytan/gstack `careful/` | Destructive command guardrails (hook-based) | `careful/SKILL.md`, `careful/bin/check-careful.sh` |
| `reflect` | poteto/noodle `.agents/skills/reflect/` | Post-task learning capture, routes learnings to AGENTS.md/skills/docs | `reflect/SKILL.md` |

## Principles and Their Source

All 13 principles are adapted from poteto/noodle `brain/principles/`. Watch for changes in:
- `brain/principles/*.md` — updates to existing principles
- `brain/principles.md` — new principles being added

## What Counts as a Relevant Change

**High relevance (recommend PR):**
- Methodology changes in source skills (new steps, changed workflow, removed anti-patterns)
- New principles added to noodle that are universally applicable
- Bug fixes or improvements to the careful hook script
- New anti-rationalization patterns or red flags discovered
- Changes to reviewer lenses or verdict formats

**Medium relevance (mention in PR, let human decide):**
- New skills added to upstream repos that might be useful
- Significant restructuring of upstream skill organization
- New reference files added to source skills

**Low relevance (skip, don't create PR):**
- Framework-specific changes (gstack telemetry, noodle session system, preamble blocks)
- Web/UI-specific skills (qa, browse, design-review, design-html, etc.)
- Infrastructure changes (CI, build scripts, test harnesses)
- Version bumps, README updates, changelog entries
- Changes to skills we don't use

## How to Recommend Updates

When recommending changes, be specific:
- Name the exact file in our repo that should be updated
- Quote the relevant upstream change
- Explain what to modify and why
- If a new upstream skill looks useful, explain what it does and whether it fits our Go/smart-contract focus
