# About Me
- Name: Hao
- GitHub: Chrakimnas6
- Current year: 2026 (focus your research on the past three months)

# Global Guidelines

## General

- Actively search the web when unsure — especially for AI tooling, libraries, and best practices which update rapidly.
- Never assume anything. Confirm with the user when requirements, scope, or approach is unclear. Present options with trade-offs.

## GitHub Repo Fetching
When needing to read/explore a GitHub repo, first check if it's already cloned locally:
- To find an existing local repo, run `ghq list --full-path | grep <repo-name>`
- If not found, clone using `ghq get https://github.com/owner/repo` — repos are stored under `~/src/github.com/`

## Fetching X/Twitter Content
WebFetch fails on `x.com` / `twitter.com`. Use the `claude-in-chrome` MCP tools instead — the Chrome session is authenticated.
