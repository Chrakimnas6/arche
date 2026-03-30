---
name: careful
description: Destructive command guardrails. Always active via PreToolUse hook — warns before rm -rf, DROP TABLE, force-push, git reset --hard, kubectl delete, and similar destructive operations. User can override each warning.
---

# Careful — Destructive Command Guardrails

Safety guardrails are **always active** via a PreToolUse hook on Bash commands. Every bash command is checked for destructive patterns before running. If a match is detected, you'll be warned and can choose to proceed or cancel.

## What's protected

| Pattern | Example | Risk |
|---------|---------|------|
| `rm -rf` / `rm -r` / `rm --recursive` | `rm -rf /var/data` | Recursive delete |
| `DROP TABLE` / `DROP DATABASE` | `DROP TABLE users;` | Data loss |
| `TRUNCATE` | `TRUNCATE orders;` | Data loss |
| `git push --force` / `-f` | `git push -f origin main` | History rewrite |
| `git reset --hard` | `git reset --hard HEAD~3` | Uncommitted work loss |
| `git checkout .` / `git restore .` | `git checkout .` | Uncommitted work loss |
| `kubectl delete` | `kubectl delete pod` | Production impact |
| `docker rm -f` / `docker system prune` | `docker system prune -a` | Container/image loss |

## Safe exceptions

These patterns are allowed without warning:
- `rm -rf node_modules` / `dist` / `__pycache__` / `.cache` / `build` / `coverage`

## How it works

The hook reads the command from the tool input JSON, checks it against the patterns above, and returns a warning with `permissionDecision: "ask"` if a match is found. You can always override the warning and proceed.
