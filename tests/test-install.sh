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
  local variable_name="$1"
  local path
  path="$(mktemp -d)"
  TMP_DIRS+=("$path")
  printf -v "$variable_name" '%s' "$path"
}

make_fixture() {
  local fixture="$1"
  mkdir -p "$fixture"
  cp "$ROOT/install.sh" "$fixture/install.sh"
  cp -R "$ROOT/install" "$fixture/install"
  cp -R "$ROOT/memory" "$fixture/memory"
  cp -R "$ROOT/skills" "$fixture/skills"
}

make_git_remote() {
  local fixture="$1" bare="$2"
  git -C "$fixture" init -q
  git -C "$fixture" config user.email test@example.com
  git -C "$fixture" config user.name "Installer Test"
  git -C "$fixture" add .
  git -C "$fixture" commit -qm "test fixture"
  git -C "$fixture" branch -M main
  git clone -q --bare "$fixture" "$bare"
}

run_streamed_installer() {
  local script="$1" home="$2" remote="$3"
  (
    cd "$(dirname "$home")"
    CODEX_HOME="$home" UPSTREAM_REPOSITORY="$remote" bash < "$script"
  )
}

pass() { printf 'PASS: %s\n' "$1"; PASSED=$((PASSED + 1)); }
fail() { printf 'FAIL: %s — %s\n' "$1" "$2" >&2; FAILED=$((FAILED + 1)); }

test_missing_source_preserves_existing_install() {
  local name="missing source preserves existing install" fixture home
  new_temp fixture; new_temp home; make_fixture "$fixture"
  rm -rf "$fixture/skills/codex-self-improvement"
  mkdir -p "$home/skills/codex-self-improvement"
  printf 'keep-me\n' > "$home/skills/codex-self-improvement/sentinel.txt"
  if CODEX_HOME="$home" bash "$fixture/install.sh" >/dev/null 2>&1; then fail "$name" "installer unexpectedly succeeded"; return; fi
  [[ -f "$home/skills/codex-self-improvement/sentinel.txt" ]] && pass "$name" || fail "$name" "existing installation was deleted before preflight completed"
}

test_python_is_not_required() {
  local name="shell installer has no Python runtime dependency" fixture home fakebin
  new_temp fixture; new_temp home; new_temp fakebin; make_fixture "$fixture"
  cat > "$fakebin/python3" <<'SH'
#!/usr/bin/env sh
exit 97
SH
  chmod +x "$fakebin/python3"
  if PATH="$fakebin:$PATH" CODEX_HOME="$home" bash "$fixture/install.sh" >/dev/null 2>&1; then pass "$name"; else fail "$name" "installer attempted to use python3"; fi
}

test_universal_refresh_removes_stale_directories() {
  local name="universal refresh removes stale directories" fixture home
  new_temp fixture; new_temp home; make_fixture "$fixture"
  mkdir -p "$home/self-improvement/universal/stale/subdir"
  printf 'stale\n' > "$home/self-improvement/universal/stale/subdir/file.txt"
  if ! CODEX_HOME="$home" bash "$fixture/install.sh" >/dev/null 2>&1; then fail "$name" "installer failed"; return; fi
  [[ ! -e "$home/self-improvement/universal/stale" ]] && pass "$name" || fail "$name" "stale universal directory survived refresh"
}

test_reinstall_preserves_private_and_refreshes_universal() {
  local name="reinstall preserves private state and refreshes universal snapshot" fixture home queue_file universal_file marker_count
  new_temp fixture; new_temp home; make_fixture "$fixture"
  if ! CODEX_HOME="$home" bash "$fixture/install.sh" >/dev/null 2>&1; then fail "$name" "first install failed"; return; fi
  queue_file="$home/self-improvement/private/UPSTREAM_QUEUE.md"
  universal_file="$home/self-improvement/universal/ACTIVE_PATTERNS.md"
  printf '\nstatus: pending\ncontribution_id: universal-test-1234\n' >> "$queue_file"
  printf '\nsource-refresh-marker\n' >> "$fixture/memory/ACTIVE_PATTERNS.md"
  if ! CODEX_HOME="$home" bash "$fixture/install.sh" >/dev/null 2>&1; then fail "$name" "second install failed"; return; fi
  marker_count="$(grep -Fc '<!-- codex-self-improvement:start -->' "$home/AGENTS.md" || true)"
  if grep -Fq 'contribution_id: universal-test-1234' "$queue_file" && grep -Fq 'source-refresh-marker' "$universal_file" && [[ "$marker_count" == "1" ]]; then pass "$name"; else fail "$name" "private queue, universal refresh, or activation idempotency failed"; fi
}

test_unmatched_agents_markers_preserve_install() {
  local name="unmatched AGENTS markers fail before activation" fixture home
  new_temp fixture; new_temp home; make_fixture "$fixture"
  mkdir -p "$home/skills/codex-self-improvement"
  printf 'keep-me\n' > "$home/skills/codex-self-improvement/sentinel.txt"
  printf '<!-- codex-self-improvement:start -->\nbroken\n' > "$home/AGENTS.md"
  if CODEX_HOME="$home" bash "$fixture/install.sh" >/dev/null 2>&1; then fail "$name" "installer unexpectedly accepted malformed markers"; return; fi
  [[ -f "$home/skills/codex-self-improvement/sentinel.txt" ]] && pass "$name" || fail "$name" "active install changed before marker validation completed"
}

test_streamed_bootstrap_installs_from_persistent_checkout() {
  local name="streamed bootstrap installs from persistent checkout" fixture home bare checkout
  new_temp fixture; new_temp home; new_temp bare
  rm -rf "$bare"
  make_fixture "$fixture"
  make_git_remote "$fixture" "$bare"
  if ! run_streamed_installer "$fixture/install.sh" "$home" "$bare" >/dev/null 2>&1; then fail "$name" "streamed installer failed"; return; fi
  checkout="$(cat "$home/self-improvement/UPSTREAM_LOCATION" 2>/dev/null || true)"
  if [[ -f "$home/skills/codex-self-improvement/SKILL.md" && -d "$checkout/.git" && "$checkout" == "$home/self-improvement/upstream-checkout" ]]; then pass "$name"; else fail "$name" "skill or persistent checkout missing"; fi
}

test_streamed_bootstrap_failure_preserves_existing_install() {
  local name="streamed bootstrap failure preserves existing install" fixture home
  new_temp fixture; new_temp home; make_fixture "$fixture"
  mkdir -p "$home/skills/codex-self-improvement"
  printf 'keep-me\n' > "$home/skills/codex-self-improvement/sentinel.txt"
  if run_streamed_installer "$fixture/install.sh" "$home" "$home/missing.git" >/dev/null 2>&1; then fail "$name" "invalid remote unexpectedly succeeded"; return; fi
  [[ -f "$home/skills/codex-self-improvement/sentinel.txt" ]] && pass "$name" || fail "$name" "active install changed during bootstrap failure"
}

test_streamed_reinstall_updates_checkout_and_preserves_private() {
  local name="streamed reinstall updates checkout and preserves private state" fixture home bare queue_file universal_file
  new_temp fixture; new_temp home; new_temp bare
  rm -rf "$bare"
  make_fixture "$fixture"
  make_git_remote "$fixture" "$bare"
  if ! run_streamed_installer "$fixture/install.sh" "$home" "$bare" >/dev/null 2>&1; then fail "$name" "first streamed install failed"; return; fi
  queue_file="$home/self-improvement/private/UPSTREAM_QUEUE.md"
  universal_file="$home/self-improvement/universal/ACTIVE_PATTERNS.md"
  printf '\nstatus: pending\ncontribution_id: streamed-test-1234\n' >> "$queue_file"
  printf '\nstreamed-refresh-marker\n' >> "$fixture/memory/ACTIVE_PATTERNS.md"
  git -C "$fixture" add memory/ACTIVE_PATTERNS.md
  git -C "$fixture" commit -qm "refresh fixture"
  git -C "$fixture" remote add origin "$bare"
  git -C "$fixture" push -q origin main
  if ! run_streamed_installer "$fixture/install.sh" "$home" "$bare" >/dev/null 2>&1; then fail "$name" "second streamed install failed"; return; fi
  if grep -Fq 'contribution_id: streamed-test-1234' "$queue_file" && grep -Fq 'streamed-refresh-marker' "$universal_file"; then pass "$name"; else fail "$name" "managed checkout did not refresh or private state was lost"; fi
}

test_streamed_repository_override_retargets_managed_checkout() {
  local name="streamed repository override retargets managed checkout" fixture_a fixture_b home bare_a bare_b universal_file origin_url
  new_temp fixture_a; new_temp fixture_b; new_temp home; new_temp bare_a; new_temp bare_b
  rm -rf "$bare_a" "$bare_b"
  make_fixture "$fixture_a"
  make_git_remote "$fixture_a" "$bare_a"
  if ! run_streamed_installer "$fixture_a/install.sh" "$home" "$bare_a" >/dev/null 2>&1; then fail "$name" "initial streamed install failed"; return; fi
  make_fixture "$fixture_b"
  printf '\nrepository-override-marker\n' >> "$fixture_b/memory/ACTIVE_PATTERNS.md"
  make_git_remote "$fixture_b" "$bare_b"
  if ! run_streamed_installer "$fixture_b/install.sh" "$home" "$bare_b" >/dev/null 2>&1; then fail "$name" "override streamed install failed"; return; fi
  universal_file="$home/self-improvement/universal/ACTIVE_PATTERNS.md"
  origin_url="$(git -C "$home/self-improvement/upstream-checkout" remote get-url origin 2>/dev/null || true)"
  if grep -Fq 'repository-override-marker' "$universal_file" && [[ "$origin_url" == "$bare_b" ]]; then pass "$name"; else fail "$name" "managed checkout kept the previous origin"; fi
}

test_missing_source_preserves_existing_install
test_python_is_not_required
test_universal_refresh_removes_stale_directories
test_reinstall_preserves_private_and_refreshes_universal
test_unmatched_agents_markers_preserve_install
test_streamed_bootstrap_installs_from_persistent_checkout
test_streamed_bootstrap_failure_preserves_existing_install
test_streamed_reinstall_updates_checkout_and_preserves_private
test_streamed_repository_override_retargets_managed_checkout

printf '\nInstaller tests: %d passed, %d failed\n' "$PASSED" "$FAILED"
[[ "$FAILED" -eq 0 ]]
