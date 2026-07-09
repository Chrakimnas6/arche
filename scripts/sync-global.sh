#!/usr/bin/env bash
# Compares the user-level agent configs (~/.claude for Claude Code, ~/.codex
# for Codex, ~/.agents for the tool-agnostic Agent Skills convention) against
# this repo and keeps them in sync:
#   - every skill in .agents/skills/ gets a symlink in ~/.claude/skills/,
#     ~/.agents/skills/, and ~/.codex/skills/ (all read the same SKILL.md
#     format); every agent in .agents/agents/ gets one in ~/.claude/agents/
#     (subagent definitions are Claude Code-specific, so they sync nowhere else)
#   - symlinks that point into this repo but no longer resolve are pruned
#     (renamed or removed skills)
#   - entries in the global dirs that don't come from this repo are reported
#     as global-only (candidates to adopt into arche) but never touched
#   - global/CLAUDE.md (the committed copy) is diffed against
#     ~/.claude/CLAUDE.md and ~/.codex/AGENTS.md
#
# Idempotent — run it any time, e.g. after adding a skill or agent:
#   bash scripts/sync-global.sh          # sync + report
#   bash scripts/sync-global.sh --check  # report only, change nothing;
#                                        # exits 1 if out of sync

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
CLAUDE_DIR="${CLAUDE_DIR:-$HOME/.claude}"
CODEX_DIR="${CODEX_DIR:-$HOME/.codex}"
AGENTS_DIR="${AGENTS_DIR:-$HOME/.agents}"

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

# The committed global/CLAUDE.md is the source of truth for both tools'
# user-level instruction files — diff, don't overwrite
diff_global_copy() {
  local live="$1"
  [ -f "$live" ] || return 0
  if diff -q "$REPO_ROOT/global/CLAUDE.md" "$live" >/dev/null 2>&1; then
    printf '%s: in sync with global/CLAUDE.md\n' "$live"
  else
    printf 'warn: global/CLAUDE.md and %s differ — reconcile manually:\n' "$live"
    diff -u "$REPO_ROOT/global/CLAUDE.md" "$live" || true
    WARNED=$((WARNED + 1))
  fi
}

# One symlink per skill directory into the given target
sync_skills_into() {
  local dest="$1" skill_dir
  [ "$CHECK" = 1 ] || mkdir -p "$dest"
  for skill_dir in "$REPO_ROOT"/.agents/skills/*/; do
    [ -f "$skill_dir/SKILL.md" ] || continue
    ensure_link "${skill_dir%/}" "$dest/$(basename "$skill_dir")"
  done
  prune_dangling "$dest"
}

for skill_dir in "$REPO_ROOT"/.agents/skills/*/; do
  [ -f "$skill_dir/SKILL.md" ] || continue
  SKILLS=$((SKILLS + 1))
done

# Claude Code
sync_skills_into "$CLAUDE_DIR/skills"
[ "$CHECK" = 1 ] || mkdir -p "$CLAUDE_DIR/agents"
for agent_file in "$REPO_ROOT"/.agents/agents/*.md; do
  [ -e "$agent_file" ] || continue
  AGENTS=$((AGENTS + 1))
  ensure_link "$agent_file" "$CLAUDE_DIR/agents/$(basename "$agent_file")"
done
prune_dangling "$CLAUDE_DIR/agents"
report_global_only "$CLAUDE_DIR/skills" "claude skills"
report_global_only "$CLAUDE_DIR/agents" "claude agents"
diff_global_copy "$CLAUDE_DIR/CLAUDE.md"

# Tool-agnostic standard location (Gemini CLI and other convention-following tools)
sync_skills_into "$AGENTS_DIR/skills"
report_global_only "$AGENTS_DIR/skills" "standard-location skills"

# Codex (its bundled skills live in skills/.system/, which the dot-excluding
# glob leaves alone)
if [ -d "$CODEX_DIR" ]; then
  sync_skills_into "$CODEX_DIR/skills"
  report_global_only "$CODEX_DIR/skills" "codex skills"
  diff_global_copy "$CODEX_DIR/AGENTS.md"
else
  printf 'codex: %s not found — skipping codex sync\n' "$CODEX_DIR"
fi

printf 'coverage: %d skills + %d agents in repo, targeting %s, %s, and %s\n' "$SKILLS" "$AGENTS" "$CLAUDE_DIR" "$AGENTS_DIR" "$CODEX_DIR"

if [ "$CHECK" = 1 ]; then
  printf 'sync-global --check: %d missing, %d stale, %d warnings\n' "$LINKED" "$PRUNED" "$WARNED"
  if [ $((LINKED + PRUNED)) -gt 0 ]; then
    printf 'out of sync — run: bash scripts/sync-global.sh\n'
    exit 1
  fi
else
  printf 'sync-global: %d linked, %d pruned, %d warnings\n' "$LINKED" "$PRUNED" "$WARNED"
fi
