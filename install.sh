#!/usr/bin/env bash
set -euo pipefail

fail() {
  printf 'Install failed: %s\n' "$1" >&2
  exit 1
}

has_repo_layout() {
  local root="$1"
  [[ -f "$root/install.sh" &&
     -d "$root/skills/codex-self-improvement" &&
     -d "$root/memory/private-template" &&
     -f "$root/install/AGENTS-snippet.md" ]]
}

resolve_script_root() {
  local source="${BASH_SOURCE[0]:-}"
  [[ -n "$source" && -f "$source" ]] || return 1
  cd "$(dirname "$source")" && pwd
}

bootstrap_streamed_install() {
  local repository checkout explicit_checkout temp_checkout="" current_origin backup_checkout
  repository="${UPSTREAM_REPOSITORY:-${SELF_IMPROVEMENT_UPSTREAM_REPOSITORY:-https://github.com/DH-stream/Codex-Self-Improvement-Skill.git}}"
  explicit_checkout="${UPSTREAM_LOCATION:-${SELF_IMPROVEMENT_UPSTREAM_CHECKOUT:-}}"
  checkout="${explicit_checkout:-$CODEX_HOME/self-improvement/upstream-checkout}"

  [[ -n "$repository" ]] || fail "upstream repository is empty"

  if [[ -n "$explicit_checkout" ]]; then
    has_repo_layout "$checkout" || fail "supplied upstream checkout is incomplete: $checkout"
  else
    command -v git >/dev/null 2>&1 || fail "git is required for streamed installation"
    mkdir -p "$(dirname "$checkout")"

    if git -C "$checkout" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
      current_origin="$(git -C "$checkout" remote get-url origin 2>/dev/null)" || fail "managed upstream checkout has no origin remote"
      if [[ "$current_origin" != "$repository" ]]; then
        temp_checkout="${checkout}.install.$$"
        backup_checkout="${checkout}.backup.$$"
        cleanup_bootstrap() {
          [[ -z "$temp_checkout" ]] || rm -rf "$temp_checkout"
          [[ ! -e "$backup_checkout" ]] || rm -rf "$backup_checkout"
        }
        trap cleanup_bootstrap EXIT
        rm -rf "$temp_checkout" "$backup_checkout"
        git clone --quiet --branch main --single-branch "$repository" "$temp_checkout" || fail "could not clone replacement upstream repository"
        has_repo_layout "$temp_checkout" || fail "replacement upstream checkout is incomplete"
        mv "$checkout" "$backup_checkout" || fail "could not stage existing upstream checkout"
        if ! mv "$temp_checkout" "$checkout"; then
          mv "$backup_checkout" "$checkout" || true
          fail "could not activate replacement upstream checkout"
        fi
        temp_checkout=""
        rm -rf "$backup_checkout"
      else
        git -C "$checkout" fetch origin main || fail "could not fetch upstream main"
        git -C "$checkout" checkout main >/dev/null 2>&1 || fail "could not checkout upstream main"
        git -C "$checkout" pull --ff-only origin main || fail "upstream checkout is not fast-forwardable"
        has_repo_layout "$checkout" || fail "updated upstream checkout is incomplete: $checkout"
      fi
    elif [[ -e "$checkout" ]]; then
      fail "managed upstream checkout exists but is not a Git repository: $checkout"
    else
      temp_checkout="${checkout}.install.$$"
      cleanup_bootstrap() {
        [[ -z "$temp_checkout" ]] || rm -rf "$temp_checkout"
      }
      trap cleanup_bootstrap EXIT
      rm -rf "$temp_checkout"
      git clone --quiet --branch main --single-branch "$repository" "$temp_checkout" || fail "could not clone upstream repository"
      has_repo_layout "$temp_checkout" || fail "cloned upstream checkout is incomplete"
      mv "$temp_checkout" "$checkout" || fail "could not activate upstream checkout"
      temp_checkout=""
    fi
  fi

  exec env UPSTREAM_LOCATION="$checkout" UPSTREAM_REPOSITORY="$repository" bash "$checkout/install.sh"
}

CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
[[ -n "$CODEX_HOME" && "$CODEX_HOME" != "/" ]] || fail "CODEX_HOME must be a non-root directory"

REPO_ROOT="$(resolve_script_root || true)"
if [[ -z "$REPO_ROOT" ]] || ! has_repo_layout "$REPO_ROOT"; then
  bootstrap_streamed_install
fi
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

for name in UX_TASTE.md UX_TASTE_HISTORY.md; do
  legacy="$LEGACY_MEMORY/$name"
  destination="$PRIVATE_TARGET/$name"
  if [[ -f "$legacy" && ! -e "$destination" ]]; then
    cp "$legacy" "$destination"
  fi
done

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
