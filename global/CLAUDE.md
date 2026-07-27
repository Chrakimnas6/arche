# About Me
- Name: Hao
- GitHub: Chrakimnas6
- Current year: 2026 (focus your research on the past three months)

# Global Guidelines

## Voice Input

I often dictate prompts via voice input, so expect transcription errors: homophones ("to" for "two", "right" for "write"), dropped or merged words, odd phrasing. Read past these and infer the intended word from context — don't take a suspicious word literally. If the ambiguity genuinely changes what I'm asking for, confirm with me before acting instead of guessing.

## General

- Actively search the web when unsure — especially for AI tooling, libraries, and best practices which update rapidly.
- Direction unclear? Confirm scope and present options. Direction set? Proceed on reversible steps and present results — see `never-block-on-the-human`.

## Engineering Principles

Before acting on design or implementation tasks, read the principles index at `~/src/github.com/Chrakimnas6/arche/docs/principles/index.md`. Read its **Always read** baseline, then each principle whose **Apply when** clause matches the task (the index's routing matrix covers common shapes) — not the whole corpus. These govern all decisions — unless the current project has its own `docs/principles/`, in which case use those instead.

## GitHub Repo Fetching
When needing to read/explore a GitHub repo, first check if it's already cloned locally:
- To find an existing local repo, run `ghq list --full-path | grep <repo-name>`
- If not found, clone using `ghq get https://github.com/owner/repo` — repos are stored under `~/src/github.com/`

## Fetching X/Twitter Content
WebFetch fails on `x.com` / `twitter.com` directly.
- **Single tweet:** swap host to `api.fxtwitter.com` (keep the path) and fetch — free JSON, no auth.
- **Timelines/search/login-gated:** use `claude-in-chrome` MCP (authenticated Chrome session).
