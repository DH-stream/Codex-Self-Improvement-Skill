#!/usr/bin/env bash
set -u

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PASSED=0
FAILED=0
TMP_DIRS=()

cleanup() {
  for path in "${TMP_DIRS[@]:-}"; do
    [[ -n "$path" ]] && rm -rf "$path"
  done
}
trap cleanup EXIT

new_temp() {
  local path
  path="$(mktemp -d)"
  TMP_DIRS+=("$path")
  printf '%s\n' "$path"
}

make_fixture() {
  local fixture="$1"
  mkdir -p "$fixture"
  cp "$ROOT/install.sh" "$fixture/install.sh"
  cp -R "$ROOT/install" "$fixture/install"
  cp -R "$ROOT/memory" "$fixture/memory"
  cp -R "$ROOT/skills" "$fixture/skills"
}

pass() {
  printf 'PASS: %s\n' "$1"
  PASSED=$((PASSED + 1))
}

fail() {
  printf 'FAIL: %s — %s\n' "$1" "$2" >&2
  FAILED=$((FAILED + 1))
}

test_missing_source_preserves_existing_install() {
  local name="missing source preserves existing install"
  local fixture home
  fixture="$(new_temp)"
  home="$(new_temp)"
  make_fixture "$fixture"
  rm -rf "$fixture/skills/codex-self-improvement"
  mkdir -p "$home/skills/codex-self-improvement"
  printf 'keep-me\n' > "$home/skills/codex-self-improvement/sentinel.txt"

  if CODEX_HOME="$home" bash "$fixture/install.sh" >/dev/null 2>&1; then
    fail "$name" "installer unexpectedly succeeded"
    return
  fi

  if [[ -f "$home/skills/codex-self-improvement/sentinel.txt" ]]; then
    pass "$name"
  else
    fail "$name" "existing installation was deleted before preflight completed"
  fi
}

test_python_is_not_required() {
  local name="shell installer has no Python runtime dependency"
  local fixture home fakebin
  fixture="$(new_temp)"
  home="$(new_temp)"
  fakebin="$(new_temp)"
  make_fixture "$fixture"
  cat > "$fakebin/python3" <<'SH'
#!/usr/bin/env sh
exit 97
SH
  chmod +x "$fakebin/python3"

  if PATH="$fakebin:$PATH" CODEX_HOME="$home" bash "$fixture/install.sh" >/dev/null 2>&1; then
    pass "$name"
  else
    fail "$name" "installer attempted to use python3"
  fi
}

test_universal_refresh_removes_stale_directories() {
  local name="universal refresh removes stale directories"
  local fixture home
  fixture="$(new_temp)"
  home="$(new_temp)"
  make_fixture "$fixture"
  mkdir -p "$home/self-improvement/universal/stale/subdir"
  printf 'stale\n' > "$home/self-improvement/universal/stale/subdir/file.txt"

  if ! CODEX_HOME="$home" bash "$fixture/install.sh" >/dev/null 2>&1; then
    fail "$name" "installer failed"
    return
  fi

  if [[ ! -e "$home/self-improvement/universal/stale" ]]; then
    pass "$name"
  else
    fail "$name" "stale universal directory survived refresh"
  fi
}

test_missing_source_preserves_existing_install
test_python_is_not_required
test_universal_refresh_removes_stale_directories

printf '\nInstaller tests: %d passed, %d failed\n' "$PASSED" "$FAILED"
[[ "$FAILED" -eq 0 ]]
