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

## Claude for Chrome
General interaction:
- For simple tasks (clicking buttons, filling forms, reading static content): use `read_page` for element refs, `find` to locate elements by description, and `computer` with `ref` to interact — avoid coordinates
- For complex tasks (scrolling, accumulating data, multi-step DOM logic): use `javascript_tool` for direct DOM manipulation
- Prefer `get_page_text` or `read_page` over screenshots — screenshots are token-expensive
- Never take screenshots unless explicitly requested

Twitter/X thread fetching:
- Twitter uses a virtualized DOM — only visible tweets are in the DOM at any time
- Click all "show more" buttons before extracting text
- Scroll incrementally (not all at once), clicking "show more" and collecting tweets at each step
- Store results in a window variable to accumulate across scroll positions
- Always verify you've captured all expected items before summarizing

## GitHub Repo Fetching
When needing to read/explore a GitHub repo, first check if it's already cloned locally:
- To find an existing local repo, run `ghq list --full-path | grep <repo-name>`
- If not found, clone using `ghq get https://github.com/owner/repo` — repos are stored under `~/src/github.com/`
