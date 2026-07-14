#!/usr/bin/env bash
set -euo pipefail

fail() {
  printf 'Install failed: %s\n' "$1" >&2
  exit 1
}

CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
[[ -n "$CODEX_HOME" && "$CODEX_HOME" != "/" ]] || fail "CODEX_HOME must be a non-root directory"

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_SOURCE="$REPO_ROOT/skills/codex-self-improvement"
MEMORY_SOURCE="$REPO_ROOT/memory"
PRIVATE_TEMPLATE="$MEMORY_SOURCE/private-template"
SNIPPET_PATH="$REPO_ROOT/install/AGENTS-snippet.md"

[[ -d "$SKILL_SOURCE" ]] || fail "missing skill source: $SKILL_SOURCE"
[[ -d "$MEMORY_SOURCE" ]] || fail "missing memory source: $MEMORY_SOURCE"
[[ -d "$PRIVATE_TEMPLATE" ]] || fail "missing private template: $PRIVATE_TEMPLATE"
[[ -f "$SNIPPET_PATH" ]] || fail "missing activation snippet: $SNIPPET_PATH"

UPSTREAM_CHECKOUT="${UPSTREAM_LOCATION:-${SELF_IMPROVEMENT_UPSTREAM_CHECKOUT:-$REPO_ROOT}}"
UPSTREAM_REPOSITORY="${UPSTREAM_REPOSITORY:-${SELF_IMPROVEMENT_UPSTREAM_REPOSITORY:-https://github.com/DH-stream/Codex-Self-Improvement-Skill.git}}"
[[ -d "$UPSTREAM_CHECKOUT" ]] || fail "upstream checkout does not exist: $UPSTREAM_CHECKOUT"
[[ -n "$UPSTREAM_REPOSITORY" ]] || fail "upstream repository is empty"
UPSTREAM_CHECKOUT="$(cd "$UPSTREAM_CHECKOUT" && pwd)"

mkdir -p "$CODEX_HOME" "$CODEX_HOME/skills"
CODEX_HOME="$(cd "$CODEX_HOME" && pwd)"

SKILL_TARGET="$CODEX_HOME/skills/codex-self-improvement"
STATE_ROOT="$CODEX_HOME/self-improvement"
UNIVERSAL_TARGET="$STATE_ROOT/universal"
PRIVATE_TARGET="$STATE_ROOT/private"
LEGACY_MEMORY="$STATE_ROOT/memory"
AGENTS_PATH="$CODEX_HOME/AGENTS.md"

mkdir -p "$STATE_ROOT" "$PRIVATE_TARGET"
STAGE_ROOT="$(mktemp -d "$STATE_ROOT/.install.XXXXXX")"
cleanup() {
  rm -rf "$STAGE_ROOT"
}
trap cleanup EXIT

SKILL_STAGE="$STAGE_ROOT/skill"
UNIVERSAL_STAGE="$STAGE_ROOT/universal"
AGENTS_INPUT="$STAGE_ROOT/AGENTS.input"
AGENTS_STAGE="$STAGE_ROOT/AGENTS.md"
mkdir -p "$SKILL_STAGE" "$UNIVERSAL_STAGE"

# Build complete replacements before touching the active installation.
cp -R "$SKILL_SOURCE"/. "$SKILL_STAGE"/
for source in "$MEMORY_SOURCE"/*; do
  [[ -f "$source" ]] || continue
  cp "$source" "$UNIVERSAL_STAGE/$(basename "$source")"
done

if [[ -f "$AGENTS_PATH" ]]; then
  cp "$AGENTS_PATH" "$AGENTS_INPUT"
else
  : > "$AGENTS_INPUT"
fi

START_MARKER='<!-- codex-self-improvement:start -->'
END_MARKER='<!-- codex-self-improvement:end -->'
START_COUNT="$(grep -Fxc "$START_MARKER" "$AGENTS_INPUT" || true)"
END_COUNT="$(grep -Fxc "$END_MARKER" "$AGENTS_INPUT" || true)"
[[ "$START_COUNT" == "$END_COUNT" ]] || fail "AGENTS.md has unmatched self-improvement markers"

awk -v start="$START_MARKER" -v end="$END_MARKER" -v snippet_file="$SNIPPET_PATH" '
function emit_snippet( line) {
  while ((getline line < snippet_file) > 0) print line
  close(snippet_file)
}
BEGIN { in_block = 0; emitted = 0 }
$0 == start {
  if (!emitted) emit_snippet()
  emitted = 1
  in_block = 1
  next
}
in_block {
  if ($0 == end) in_block = 0
  next
}
{ print }
END {
  if (!emitted) {
    if (NR > 0) print ""
    emit_snippet()
  }
}
' "$AGENTS_INPUT" > "$AGENTS_STAGE"

[[ "$(grep -Fxc "$START_MARKER" "$AGENTS_STAGE" || true)" == "1" ]] || fail "generated AGENTS.md has invalid start marker count"
[[ "$(grep -Fxc "$END_MARKER" "$AGENTS_STAGE" || true)" == "1" ]] || fail "generated AGENTS.md has invalid end marker count"

# Preserve taste learned by the first installer layout before applying templates.
for name in UX_TASTE.md UX_TASTE_HISTORY.md; do
  legacy="$LEGACY_MEMORY/$name"
  destination="$PRIVATE_TARGET/$name"
  if [[ -f "$legacy" && ! -e "$destination" ]]; then
    cp "$legacy" "$destination"
  fi
done

# Private state is seeded once and never overwritten by reinstall or sync.
for source in "$PRIVATE_TEMPLATE"/*; do
  [[ -f "$source" ]] || continue
  destination="$PRIVATE_TARGET/$(basename "$source")"
  [[ -e "$destination" ]] || cp "$source" "$destination"
done

SKILL_BACKUP="$STAGE_ROOT/skill.backup"
UNIVERSAL_BACKUP="$STAGE_ROOT/universal.backup"
[[ ! -e "$SKILL_TARGET" ]] || mv "$SKILL_TARGET" "$SKILL_BACKUP"
[[ ! -e "$UNIVERSAL_TARGET" ]] || mv "$UNIVERSAL_TARGET" "$UNIVERSAL_BACKUP"

rollback_directories() {
  rm -rf "$SKILL_TARGET" "$UNIVERSAL_TARGET"
  [[ ! -e "$SKILL_BACKUP" ]] || mv "$SKILL_BACKUP" "$SKILL_TARGET"
  [[ ! -e "$UNIVERSAL_BACKUP" ]] || mv "$UNIVERSAL_BACKUP" "$UNIVERSAL_TARGET"
}

if ! mv "$SKILL_STAGE" "$SKILL_TARGET"; then
  rollback_directories
  fail "could not activate staged skill"
fi
if ! mv "$UNIVERSAL_STAGE" "$UNIVERSAL_TARGET"; then
  rollback_directories
  fail "could not activate staged universal snapshot"
fi

mkdir -p "$(dirname "$AGENTS_PATH")"
if ! mv "$AGENTS_STAGE" "$AGENTS_PATH"; then
  rollback_directories
  fail "could not update global AGENTS.md"
fi

rm -rf "$SKILL_BACKUP" "$UNIVERSAL_BACKUP"
printf '%s\n' "$PRIVATE_TARGET" > "$STATE_ROOT/PRIVATE_LOCATION"
printf '%s\n' "$UNIVERSAL_TARGET" > "$STATE_ROOT/UNIVERSAL_LOCATION"
printf '%s\n' "$UPSTREAM_CHECKOUT" > "$STATE_ROOT/UPSTREAM_LOCATION"
printf '%s\n' "$UPSTREAM_REPOSITORY" > "$STATE_ROOT/UPSTREAM_REPOSITORY"

echo "Installed skill: $SKILL_TARGET"
echo "Universal snapshot: $UNIVERSAL_TARGET"
echo "Private memory: $PRIVATE_TARGET"
echo "Upstream checkout: $UPSTREAM_CHECKOUT"
echo "Updated global hook: $AGENTS_PATH"