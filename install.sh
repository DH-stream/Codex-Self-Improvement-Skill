#!/usr/bin/env bash
set -euo pipefail

CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_SOURCE="$REPO_ROOT/skills/codex-self-improvement"
SKILL_TARGET="$CODEX_HOME/skills/codex-self-improvement"
SEED_MEMORY="$REPO_ROOT/memory"
STATE_ROOT="$CODEX_HOME/self-improvement"
LOCAL_MEMORY="$STATE_ROOT/memory"
MEMORY_TARGET="$SEED_MEMORY"

if [[ "${USE_REPOSITORY_MEMORY:-0}" != "1" ]]; then
  MEMORY_TARGET="$LOCAL_MEMORY"
fi

mkdir -p "$SKILL_TARGET" "$MEMORY_TARGET" "$STATE_ROOT"
cp -R "$SKILL_SOURCE"/. "$SKILL_TARGET"/

if [[ "${USE_REPOSITORY_MEMORY:-0}" != "1" ]]; then
  for source in "$SEED_MEMORY"/*; do
    [[ -f "$source" ]] || continue
    destination="$MEMORY_TARGET/$(basename "$source")"
    [[ -e "$destination" ]] || cp "$source" "$destination"
  done
fi

printf '%s\n' "$MEMORY_TARGET" > "$STATE_ROOT/LOCATION"

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
echo "Persistent memory: $MEMORY_TARGET"
echo "Updated global hook: $AGENTS_PATH"
