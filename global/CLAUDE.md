# About Me
- Name: Hao
- GitHub: Chrakimnas6
- Current year: 2026 (focus your research on the past three months)

# Global Guidelines

## General

- Actively search the web when unsure — especially for AI tooling, libraries, and best practices which update rapidly.
- Never assume anything. Confirm with the user when requirements, scope, or approach is unclear. Present options with trade-offs.
- For creating skills from scratch or improving underperforming skills, use the `skill-creator` plugin. For straightforward adaptations or small edits, modify skill files directly.

## Long-running Jobs

If you need to wait for a long-running job, use sleep commands with manual exponential backoff: wait 1 minute, then 2 minutes, then 4 minutes, and so on.

## GitHub Repo Fetching
When needing to read/explore a GitHub repo, first check if it's already cloned locally:
- To find an existing local repo, run `ghq list --full-path | grep <repo-name>`
- If not found, clone using `ghq get https://github.com/owner/repo` — repos are stored under `~/src/github.com/`

## Fetching X/Twitter Content
WebFetch fails on `x.com` / `twitter.com`. Use the `claude-in-chrome` MCP tools instead — the Chrome session is authenticated.
