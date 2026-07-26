---
name: resolving-merge-conflicts
description: "Use when you need to resolve an in-progress git merge/rebase conflict."
---

**Always resolve; never `--abort`.**

**Find the primary sources** for each conflict — commit messages, PRs, issues — and understand why each change was made.

**Resolve each hunk** by preserving both intents. Where incompatible, pick the one matching the merge's stated goal and note the trade-off. Do **not** invent new behaviour.
