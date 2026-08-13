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

## Code Comments

Comment only to state what the code cannot show: an invariant, an external system's quirk, why the obvious approach fails. Never write comments that narrate the change, justify a decision to a reviewer, or replay design discussion — that prose belongs in the PR description, not the file. The test: would the comment still earn its place if a human had written the code and no review conversation existed? Match the surrounding file's comment density. Comments a tool or convention requires — license headers, lint or codegen directives, doc comments on public APIs — are outside this rule; write them as the project expects.

## Commit Messages & PR Descriptions

Follow the classic rules (tpope's note, cbea.ms/git-commit), yielding to project convention where they conflict: imperative subject ≤50 chars, no trailing period; when the subject alone doesn't suffice, a blank line then a body wrapped at 72 explaining what and why — the diff shows how.

Write for the repository's history, not the conversation: no "as discussed" or "per feedback", no chronology of attempts — describe the final change as one coherent story. A PR description says what changed, why, and how to review or verify it — in the repo's PR template if one exists. It is not a file-by-file tour, a feature checklist restating the diff, or a transcript of the session that produced it.

## GitHub Repo Fetching
When needing to read/explore a GitHub repo, first check if it's already cloned locally:
- To find an existing local repo, run `ghq list --full-path | grep <repo-name>`
- If not found, clone using `ghq get https://github.com/owner/repo` — repos are stored under `~/src/github.com/`

## Fetching X/Twitter Content
WebFetch fails on `x.com` / `twitter.com` directly.
- **Single tweet:** swap host to `api.fxtwitter.com` (keep the path) and fetch — free JSON, no auth.
- **Timelines/search/login-gated:** use `claude-in-chrome` MCP (authenticated Chrome session).
