# About Me
- Name: Hao
- GitHub: Chrakimnas6
- Current year: 2026 (focus your research on the past three months)

# Global Guidelines

## General

- Actively search the web when unsure — especially for AI tooling, libraries, and best practices which update rapidly.
- Never assume direction. When requirements, scope, or approach are unclear, confirm with the user and present options with trade-offs. Once direction is set, don't ask permission for reversible execution steps — proceed and present results (see the `never-block-on-the-human` principle).

## Engineering Principles

Before acting on design or implementation tasks, read the principles index at `~/src/github.com/Chrakimnas6/arche/docs/principles/index.md`. Read its **Always read** baseline, then each principle whose **Apply when** clause matches the task (the index's routing matrix covers common shapes) — not the whole corpus. These govern all decisions — unless the current project has its own `docs/principles/`, in which case use those instead.

## GitHub Repo Fetching
When needing to read/explore a GitHub repo, first check if it's already cloned locally:
- To find an existing local repo, run `ghq list --full-path | grep <repo-name>`
- If not found, clone using `ghq get https://github.com/owner/repo` — repos are stored under `~/src/github.com/`

## Fetching X/Twitter Content
WebFetch fails on `x.com` / `twitter.com`. Use the `claude-in-chrome` MCP tools instead — the Chrome session is authenticated.
