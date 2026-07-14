#!/usr/bin/env bash
set -euo pipefail

CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_SOURCE="$REPO_ROOT/skills/codex-self-improvement"
SKILL_TARGET="$CODEX_HOME/skills/codex-self-improvement"
MEMORY_SOURCE="$REPO_ROOT/memory"
PRIVATE_TEMPLATE="$MEMORY_SOURCE/private-template"
STATE_ROOT="$CODEX_HOME/self-improvement"
UNIVERSAL_TARGET="$STATE_ROOT/universal"
PRIVATE_TARGET="$STATE_ROOT/private"
LEGACY_MEMORY="$STATE_ROOT/memory"
UPSTREAM_CHECKOUT="${SELF_IMPROVEMENT_UPSTREAM_CHECKOUT:-$REPO_ROOT}"
UPSTREAM_REPOSITORY="${SELF_IMPROVEMENT_UPSTREAM_REPOSITORY:-https://github.com/DH-stream/Codex-Self-Improvement-Skill.git}"

rm -rf "$SKILL_TARGET"
mkdir -p "$SKILL_TARGET" "$UNIVERSAL_TARGET" "$PRIVATE_TARGET" "$STATE_ROOT"
cp -R "$SKILL_SOURCE"/. "$SKILL_TARGET"/

# Universal state follows the checked-out public repository on every install.
find "$UNIVERSAL_TARGET" -mindepth 1 -maxdepth 1 -type f -delete
for source in "$MEMORY_SOURCE"/*; do
  [[ -f "$source" ]] || continue
  cp "$source" "$UNIVERSAL_TARGET/$(basename "$source")"
done

# Private state is seeded once and is never overwritten by reinstall or sync.
for source in "$PRIVATE_TEMPLATE"/*; do
  [[ -f "$source" ]] || continue
  destination="$PRIVATE_TARGET/$(basename "$source")"
  [[ -e "$destination" ]] || cp "$source" "$destination"
done

# Preserve taste learned by the first installer layout.
for name in UX_TASTE.md UX_TASTE_HISTORY.md; do
  legacy="$LEGACY_MEMORY/$name"
  destination="$PRIVATE_TARGET/$name"
  if [[ -f "$legacy" && ! -e "$destination" ]]; then
    cp "$legacy" "$destination"
  fi
done

printf '%s\n' "$PRIVATE_TARGET" > "$STATE_ROOT/PRIVATE_LOCATION"
printf '%s\n' "$UNIVERSAL_TARGET" > "$STATE_ROOT/UNIVERSAL_LOCATION"
printf '%s\n' "$UPSTREAM_CHECKOUT" > "$STATE_ROOT/UPSTREAM_LOCATION"
printf '%s\n' "$UPSTREAM_REPOSITORY" > "$STATE_ROOT/UPSTREAM_REPOSITORY"

AGENTS_PATH="$CODEX_HOME/AGENTS.md"
SNIPPET_PATH="$REPO_ROOT/install/AGENTS-snippet.md"
python3 - "$AGENTS_PATH" "$SNIPPET_PATH" <<'PY'
from pathlib import Path
import re
import sys

agents_path = Path(sys.argv[1])
snippet = Path(sys.argv[2]).read_text(encoding="utf-8").strip()
existing = agents_path.read_text(encoding="utf-8") if agents_path.exists() else ""
pattern = re.compile(
    r"<!-- codex-self-improvement:start -->.*?<!-- codex-self-improvement:end -->",
    re.S,
)
if pattern.search(existing):
    updated = pattern.sub(snippet, existing)
else:
    updated = existing.rstrip() + ("\n\n" if existing.strip() else "") + snippet + "\n"
agents_path.parent.mkdir(parents=True, exist_ok=True)
agents_path.write_text(updated, encoding="utf-8")
PY

echo "Installed skill: $SKILL_TARGET"
echo "Universal memory: $UNIVERSAL_TARGET"
echo "Private memory: $PRIVATE_TARGET"
echo "Upstream checkout: $UPSTREAM_CHECKOUT"
echo "Updated global hook: $AGENTS_PATH"
