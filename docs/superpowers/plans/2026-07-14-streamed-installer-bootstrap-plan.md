# Streamed Installer Bootstrap Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make the advertised `curl | bash` and `irm | iex` commands safely install from a persistent Git checkout while preserving current local-install behavior.

**Architecture:** Both installers first detect whether they are running beside a complete repository checkout. Local execution continues unchanged. Streamed execution resolves a supplied `UPSTREAM_LOCATION` or creates/reuses `~/.codex/self-improvement/upstream-checkout`, validates it, and invokes the bundled installer from that checkout. Fresh clones stage into a temporary sibling directory before activation; existing managed checkouts update with `git pull --ff-only`.

**Tech Stack:** Bash, PowerShell, Git, existing filesystem-based installer tests.

## Global Constraints

- Existing local clone installation must remain compatible.
- A bootstrap failure must not modify the active skill, universal snapshot, private memory, or global `AGENTS.md`.
- Fresh streamed installs require Git.
- Existing managed checkouts update only through fast-forward pulls.
- `UPSTREAM_LOCATION` and `UPSTREAM_REPOSITORY` remain supported.
- No direct push, merge, approval, or ready-for-review behavior is introduced.

---

## File map

- `install.sh` — local installer plus streamed Bash bootstrap entrypoint.
- `install.ps1` — local installer plus streamed PowerShell bootstrap entrypoint.
- `tests/test-install.sh` — existing local tests plus isolated streamed Bash tests using a local bare Git remote.
- `tests/test-install.ps1` — equivalent PowerShell regression runner; skips with a clear message when no PowerShell runtime exists.

### Task 1: Add failing Bash streamed-install tests

**Files:**
- Modify: `tests/test-install.sh`

**Interfaces:**
- Produces: local Git fixture helpers and two tests that drive `install.sh` through stdin.

- [ ] **Step 1: Add Git fixture helpers**

Add helpers that create a committed source repository and bare remote:

```bash
make_git_remote() {
  local fixture="$1" bare="$2"
  git -C "$fixture" init -q
  git -C "$fixture" config user.email test@example.com
  git -C "$fixture" config user.name "Installer Test"
  git -C "$fixture" add .
  git -C "$fixture" commit -qm "test fixture"
  git clone -q --bare "$fixture" "$bare"
}

run_streamed_installer() {
  local script="$1" home="$2" remote="$3"
  (
    cd "$(dirname "$home")"
    CODEX_HOME="$home" \
    UPSTREAM_REPOSITORY="$remote" \
    bash < "$script"
  )
}
```

- [ ] **Step 2: Add a streamed-success test**

```bash
test_streamed_bootstrap_installs_from_persistent_checkout() {
  local name="streamed bootstrap installs from persistent checkout"
  local fixture home bare checkout
  new_temp fixture
  new_temp home
  new_temp bare
  rm -rf "$bare"
  make_fixture "$fixture"
  make_git_remote "$fixture" "$bare"

  if ! run_streamed_installer "$fixture/install.sh" "$home" "$bare" >/dev/null 2>&1; then
    fail "$name" "streamed installer failed"
    return
  fi

  checkout="$(cat "$home/self-improvement/UPSTREAM_LOCATION")"
  if [[ -f "$home/skills/codex-self-improvement/SKILL.md" &&
        -d "$checkout/.git" &&
        "$checkout" == "$home/self-improvement/upstream-checkout" ]]; then
    pass "$name"
  else
    fail "$name" "skill or persistent checkout missing"
  fi
}
```

- [ ] **Step 3: Add a streamed-failure preservation test**

```bash
test_streamed_bootstrap_failure_preserves_existing_install() {
  local name="streamed bootstrap failure preserves existing install"
  local fixture home
  new_temp fixture
  new_temp home
  make_fixture "$fixture"
  mkdir -p "$home/skills/codex-self-improvement"
  printf 'keep-me\n' > "$home/skills/codex-self-improvement/sentinel.txt"

  if run_streamed_installer "$fixture/install.sh" "$home" "$home/missing-remote.git" >/dev/null 2>&1; then
    fail "$name" "invalid remote unexpectedly succeeded"
    return
  fi

  if [[ -f "$home/skills/codex-self-improvement/sentinel.txt" ]]; then
    pass "$name"
  else
    fail "$name" "active install changed during bootstrap failure"
  fi
}
```

- [ ] **Step 4: Register and run the tests**

Append both functions before the final summary and invoke them after the existing tests.

Run:

```bash
bash tests/test-install.sh
```

Expected: the two new tests fail while the original five still pass.

- [ ] **Step 5: Commit the RED tests**

```bash
git add tests/test-install.sh
git commit -m "test: cover streamed bash installation"
```

### Task 2: Implement the Bash bootstrap

**Files:**
- Modify: `install.sh`

**Interfaces:**
- Consumes: `CODEX_HOME`, `UPSTREAM_LOCATION`, `UPSTREAM_REPOSITORY`.
- Produces: a validated persistent checkout at `$CODEX_HOME/self-improvement/upstream-checkout` for streamed execution.

- [ ] **Step 1: Add layout detection before local source validation**

Directly after `fail()` add:

```bash
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
```

- [ ] **Step 2: Add the streamed bootstrap function**

```bash
bootstrap_streamed_install() {
  command -v git >/dev/null 2>&1 || fail "git is required for streamed installation"

  local state_root="$CODEX_HOME/self-improvement"
  local repository="${UPSTREAM_REPOSITORY:-${SELF_IMPROVEMENT_UPSTREAM_REPOSITORY:-https://github.com/DH-stream/Codex-Self-Improvement-Skill.git}}"
  local checkout="${UPSTREAM_LOCATION:-${SELF_IMPROVEMENT_UPSTREAM_CHECKOUT:-$state_root/upstream-checkout}}"
  local temp_checkout="${checkout}.install.$$"

  [[ -n "$repository" ]] || fail "upstream repository is empty"
  mkdir -p "$state_root"

  if [[ -n "${UPSTREAM_LOCATION:-${SELF_IMPROVEMENT_UPSTREAM_CHECKOUT:-}}" ]]; then
    has_repo_layout "$checkout" || fail "supplied upstream checkout is incomplete: $checkout"
  elif [[ -d "$checkout/.git" ]]; then
    git -C "$checkout" fetch origin main || fail "could not fetch upstream main"
    git -C "$checkout" checkout main >/dev/null 2>&1 || fail "could not checkout upstream main"
    git -C "$checkout" pull --ff-only origin main || fail "upstream checkout is not fast-forwardable"
    has_repo_layout "$checkout" || fail "updated upstream checkout is incomplete: $checkout"
  elif [[ -e "$checkout" ]]; then
    fail "managed upstream checkout exists but is not a Git repository: $checkout"
  else
    rm -rf "$temp_checkout"
    trap 'rm -rf "$temp_checkout"' RETURN
    git clone --quiet --branch main --single-branch "$repository" "$temp_checkout" || fail "could not clone upstream repository"
    has_repo_layout "$temp_checkout" || fail "cloned upstream checkout is incomplete"
    mv "$temp_checkout" "$checkout" || fail "could not activate upstream checkout"
    trap - RETURN
  fi

  UPSTREAM_LOCATION="$checkout" UPSTREAM_REPOSITORY="$repository" bash "$checkout/install.sh"
  exit $?
}
```

- [ ] **Step 3: Route streamed execution into the bootstrap**

Replace the current `REPO_ROOT=...` assignment with:

```bash
CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
[[ -n "$CODEX_HOME" && "$CODEX_HOME" != "/" ]] || fail "CODEX_HOME must be a non-root directory"

REPO_ROOT="$(resolve_script_root || true)"
if [[ -z "$REPO_ROOT" ]] || ! has_repo_layout "$REPO_ROOT"; then
  bootstrap_streamed_install
fi
```

Remove the duplicate existing `CODEX_HOME` initialization below it. Keep the remainder of the local installer unchanged.

- [ ] **Step 4: Run syntax and regressions**

```bash
bash -n install.sh
bash tests/test-install.sh
```

Expected: syntax passes and all seven tests pass.

- [ ] **Step 5: Commit the Bash implementation**

```bash
git add install.sh tests/test-install.sh
git commit -m "feat: support streamed bash installation"
```

### Task 3: Add PowerShell bootstrap coverage

**Files:**
- Create: `tests/test-install.ps1`

**Interfaces:**
- Produces: a standalone PowerShell regression runner using a local bare Git remote.

- [ ] **Step 1: Create the test runner**

Create a script that:

1. copies `install.ps1`, `install/`, `memory/`, and `skills/` into a temporary fixture;
2. initializes and commits that fixture, then creates a bare Git remote;
3. launches a child PowerShell process that evaluates `install.ps1` from raw text with `CODEX_HOME` and `UPSTREAM_REPOSITORY` set;
4. asserts `SKILL.md` and the persistent `.git` directory exist;
5. repeats with a missing remote and asserts a pre-existing sentinel remains;
6. removes all temporary directories in `finally`.

Use this exact child invocation shape so `$PSScriptRoot` is empty:

```powershell
$command = @'
$ErrorActionPreference = "Stop"
$env:CODEX_HOME = $args[0]
$env:UPSTREAM_REPOSITORY = $args[1]
$source = Get-Content -Raw -LiteralPath $args[2]
Invoke-Expression $source
'@
& $PSHOME/pwsh -NoProfile -Command $command $home $bare $scriptPath
```

For Windows PowerShell, resolve the current executable with `(Get-Process -Id $PID).Path` instead of assuming `pwsh`.

- [ ] **Step 2: Run the test before implementation**

```powershell
./tests/test-install.ps1
```

Expected: streamed success fails; failure-preservation may already pass.

- [ ] **Step 3: Commit the RED test**

```bash
git add tests/test-install.ps1
git commit -m "test: cover streamed powershell installation"
```

### Task 4: Implement the PowerShell bootstrap

**Files:**
- Modify: `install.ps1`
- Test: `tests/test-install.ps1`

**Interfaces:**
- Consumes: `$CodexHome`, `$UpstreamCheckout`, `$UpstreamRepository`, and matching environment variables.
- Produces: the same persistent checkout contract as Bash.

- [ ] **Step 1: Add repository-layout detection**

After `Assert-File`, add:

```powershell
function Test-RepositoryLayout([string]$Root) {
  if ([string]::IsNullOrWhiteSpace($Root)) { return $false }
  return (Test-Path -LiteralPath (Join-Path $Root "install.ps1") -PathType Leaf) -and
    (Test-Path -LiteralPath (Join-Path $Root "skills\codex-self-improvement") -PathType Container) -and
    (Test-Path -LiteralPath (Join-Path $Root "memory\private-template") -PathType Container) -and
    (Test-Path -LiteralPath (Join-Path $Root "install\AGENTS-snippet.md") -PathType Leaf)
}
```

- [ ] **Step 2: Add `Invoke-StreamedBootstrap`**

Implement a function that:

- resolves the repository from explicit parameter, environment, then the existing GitHub default;
- resolves a supplied checkout or defaults to `<CodexHome>/self-improvement/upstream-checkout`;
- validates a supplied checkout without changing it;
- for an existing managed checkout, runs `git fetch origin main`, `git checkout main`, and `git pull --ff-only origin main`, checking `$LASTEXITCODE` after each call;
- for a fresh checkout, clones into `<checkout>.install-<guid>`, validates it, and moves it into place;
- invokes the downloaded `install.ps1` with `-CodexHome`, `-UpstreamCheckout`, and `-UpstreamRepository`;
- always deletes an unactivated temporary checkout in `finally`.

Use:

```powershell
& $installerPath -CodexHome $CodexHome -UpstreamCheckout $checkout -UpstreamRepository $repository
if ($LASTEXITCODE -ne 0) { throw "Bundled installer failed with exit code $LASTEXITCODE" }
```

- [ ] **Step 3: Route raw-text execution into the bootstrap**

Replace:

```powershell
$repoRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
```

with:

```powershell
$repoRoot = if (-not [string]::IsNullOrWhiteSpace($PSScriptRoot)) { $PSScriptRoot } else { "" }
if (-not (Test-RepositoryLayout $repoRoot)) {
  Invoke-StreamedBootstrap
  return
}
```

Keep the existing local installer body unchanged after this gate.

- [ ] **Step 4: Run PowerShell and shell regressions**

```powershell
./tests/test-install.ps1
```

```bash
bash -n install.sh
bash tests/test-install.sh
```

Expected: both streamed PowerShell tests pass where a PowerShell runtime is available, and all Bash tests remain green.

- [ ] **Step 5: Commit the PowerShell implementation**

```bash
git add install.ps1 tests/test-install.ps1
git commit -m "feat: support streamed powershell installation"
```

### Task 5: Final installer review

**Files:**
- Review: `install.sh`
- Review: `install.ps1`
- Review: `tests/test-install.sh`
- Review: `tests/test-install.ps1`

- [ ] **Step 1: Test local and streamed modes**

Run all available suites and manually verify one local checkout invocation for each available shell.

- [ ] **Step 2: Inspect the full diff against `main`**

```bash
git diff --check main...HEAD
git diff main...HEAD -- install.sh install.ps1 tests/test-install.sh tests/test-install.ps1
```

Expected: no whitespace errors; no active-install mutation occurs before bootstrap validation.

- [ ] **Step 3: Commit any review fixes**

```bash
git add install.sh install.ps1 tests/test-install.sh tests/test-install.ps1
git commit -m "fix: harden streamed installer bootstrap"
```
