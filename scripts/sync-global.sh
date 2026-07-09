#!/usr/bin/env bash
# Compares the user-level Claude Code config (~/.claude) against this repo and
# keeps them in sync:
#   - every skill in .agents/skills/ and agent in .agents/agents/ gets a
#     symlink in ~/.claude/skills/ and ~/.claude/agents/ (created if missing)
#   - symlinks that point into this repo but no longer resolve are pruned
#     (renamed or removed skills)
#   - entries in ~/.claude that don't come from this repo are reported as
#     global-only (candidates to adopt into arche) but never touched
#   - global/CLAUDE.md (the committed copy) is diffed against ~/.claude/CLAUDE.md
#
# Idempotent — run it any time, e.g. after adding a skill or agent:
#   bash scripts/sync-global.sh          # sync + report
#   bash scripts/sync-global.sh --check  # report only, change nothing;
#                                        # exits 1 if out of sync

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
CLAUDE_DIR="${CLAUDE_DIR:-$HOME/.claude}"

CHECK=0
[ "${1:-}" = "--check" ] && CHECK=1

LINKED=0 # created — or, with --check, missing
PRUNED=0 # dangling removed — or, with --check, stale
WARNED=0
SKILLS=0
AGENTS=0

ensure_link() {
  local src="$1" dest="$2"
  if [ -L "$dest" ]; then
    if [ "$(readlink "$dest")" = "$src" ]; then
      return 0
    fi
    printf 'warn: %s points to %s, expected %s — left untouched\n' "$dest" "$(readlink "$dest")" "$src"
    WARNED=$((WARNED + 1))
    return 0
  fi
  if [ -e "$dest" ]; then
    printf 'warn: %s exists and is not a symlink — left untouched\n' "$dest"
    WARNED=$((WARNED + 1))
    return 0
  fi
  if [ "$CHECK" = 1 ]; then
    printf 'missing: %s (would link -> %s)\n' "$dest" "$src"
  else
    ln -s "$src" "$dest"
    printf 'linked: %s -> %s\n' "$dest" "$src"
  fi
  LINKED=$((LINKED + 1))
}

prune_dangling() {
  local dir="$1" link target
  [ -d "$dir" ] || return 0
  for link in "$dir"/*; do
    [ -L "$link" ] || continue
    target="$(readlink "$link")"
    case "$target" in
      "$REPO_ROOT"/*)
        if [ ! -e "$link" ]; then
          if [ "$CHECK" = 1 ]; then
            printf 'stale: %s -> %s (would prune)\n' "$link" "$target"
          else
            rm "$link"
            printf 'pruned dangling: %s -> %s\n' "$link" "$target"
          fi
          PRUNED=$((PRUNED + 1))
        fi
        ;;
    esac
  done
}

# Entries in the global dir that don't point into this repo: personal skills,
# other tools' agents. Reported so nothing hides, never modified.
report_global_only() {
  local dir="$1" label="$2" entry target names=""
  [ -d "$dir" ] || return 0
  for entry in "$dir"/*; do
    { [ -e "$entry" ] || [ -L "$entry" ]; } || continue
    if [ -L "$entry" ]; then
      target="$(readlink "$entry")"
      case "$target" in
        "$REPO_ROOT"/*) continue ;;
      esac
    fi
    names="$names $(basename "$entry")"
  done
  if [ -n "$names" ]; then
    printf 'global-only %s (no arche counterpart, untouched):%s\n' "$label" "$names"
  fi
}

# Skills: one symlink per skill directory
[ "$CHECK" = 1 ] || mkdir -p "$CLAUDE_DIR/skills"
for skill_dir in "$REPO_ROOT"/.agents/skills/*/; do
  [ -f "$skill_dir/SKILL.md" ] || continue
  SKILLS=$((SKILLS + 1))
  ensure_link "${skill_dir%/}" "$CLAUDE_DIR/skills/$(basename "$skill_dir")"
done

# Agents: one symlink per agent definition file
[ "$CHECK" = 1 ] || mkdir -p "$CLAUDE_DIR/agents"
for agent_file in "$REPO_ROOT"/.agents/agents/*.md; do
  [ -e "$agent_file" ] || continue
  AGENTS=$((AGENTS + 1))
  ensure_link "$agent_file" "$CLAUDE_DIR/agents/$(basename "$agent_file")"
done

prune_dangling "$CLAUDE_DIR/skills"
prune_dangling "$CLAUDE_DIR/agents"

report_global_only "$CLAUDE_DIR/skills" "skills"
report_global_only "$CLAUDE_DIR/agents" "agents"

# global/CLAUDE.md is the committed copy of ~/.claude/CLAUDE.md — diff, don't overwrite
if [ -f "$CLAUDE_DIR/CLAUDE.md" ]; then
  if diff -q "$REPO_ROOT/global/CLAUDE.md" "$CLAUDE_DIR/CLAUDE.md" >/dev/null 2>&1; then
    printf 'CLAUDE.md: in sync with global/CLAUDE.md\n'
  else
    printf 'warn: global/CLAUDE.md and %s/CLAUDE.md differ — reconcile manually:\n' "$CLAUDE_DIR"
    diff -u "$REPO_ROOT/global/CLAUDE.md" "$CLAUDE_DIR/CLAUDE.md" || true
    WARNED=$((WARNED + 1))
  fi
fi

printf 'coverage: %d skills + %d agents in repo, targeting %s\n' "$SKILLS" "$AGENTS" "$CLAUDE_DIR"

if [ "$CHECK" = 1 ]; then
  printf 'sync-global --check: %d missing, %d stale, %d warnings\n' "$LINKED" "$PRUNED" "$WARNED"
  if [ $((LINKED + PRUNED)) -gt 0 ]; then
    printf 'out of sync — run: bash scripts/sync-global.sh\n'
    exit 1
  fi
else
  printf 'sync-global: %d linked, %d pruned, %d warnings\n' "$LINKED" "$PRUNED" "$WARNED"
fi
