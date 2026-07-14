# Streamed Installer Bootstrap Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make `curl | bash` and `irm | iex` safely install from a persistent Git checkout while preserving local installation.

**Architecture:** Each installer detects whether it runs beside a complete repository. Local execution continues unchanged. Streamed execution uses a supplied checkout or creates/reuses `<CodexHome>/self-improvement/upstream-checkout`, validates it, then invokes the bundled local installer. Fresh clones stage in a temporary sibling path; existing managed checkouts update with fast-forward-only Git operations.

**Tech Stack:** Bash, PowerShell, Git, filesystem regression tests.

## Global Constraints

- Bootstrap failure must not modify the active skill, universal snapshot, private memory, or `AGENTS.md`.
- Existing clone-based installation and environment aliases remain compatible.
- Fresh streamed installation requires Git unless a valid checkout is supplied.
- Managed checkout updates are fast-forward-only.
- No automatic merge, approval, or direct push behavior is introduced.

---

## File map

- `install.sh` — Bash bootstrap plus existing local installer.
- `install.ps1` — PowerShell bootstrap plus existing local installer.
- `tests/test-install.sh` — existing tests plus streamed Bash coverage.
- `tests/test-install.ps1` — streamed PowerShell coverage.

### Task 1: Add RED Bash streamed-install tests

**Files:**
- Modify: `tests/test-install.sh`

**Interfaces:**
- Produces: a local bare Git fixture and streamed success/failure tests.

- [ ] **Step 1: Add fixture helpers after `make_fixture`**

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
    CODEX_HOME="$home" UPSTREAM_REPOSITORY="$remote" bash < "$script"
  )
}
```

- [ ] **Step 2: Add both tests before the invocation block**

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

test_streamed_bootstrap_failure_preserves_existing_install() {
  local name="streamed bootstrap failure preserves existing install"
  local fixture home
  new_temp fixture
  new_temp home
  make_fixture "$fixture"
  mkdir -p "$home/skills/codex-self-improvement"
  printf 'keep-me\n' > "$home/skills/codex-self-improvement/sentinel.txt"

  if run_streamed_installer "$fixture/install.sh" "$home" "$home/missing.git" >/dev/null 2>&1; then
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

- [ ] **Step 3: Invoke the tests after the existing five**

```bash
test_streamed_bootstrap_installs_from_persistent_checkout
test_streamed_bootstrap_failure_preserves_existing_install
```

- [ ] **Step 4: Run RED**

```bash
bash tests/test-install.sh
```

Expected: original five pass; both streamed tests fail.

- [ ] **Step 5: Commit**

```bash
git add tests/test-install.sh
git commit -m "test: cover streamed bash installation"
```

### Task 2: Implement the Bash bootstrap

**Files:**
- Modify: `install.sh`
- Test: `tests/test-install.sh`

**Interfaces:**
- Consumes: `CODEX_HOME`, `UPSTREAM_LOCATION`, `UPSTREAM_REPOSITORY`, and legacy aliases.
- Produces: a validated persistent checkout used by the existing installer.

- [ ] **Step 1: Add these helpers after `fail()`**

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

- [ ] **Step 2: Add the complete bootstrap function below the helpers**

```bash
bootstrap_streamed_install() {
  local repository checkout explicit_checkout temp_checkout=""
  repository="${UPSTREAM_REPOSITORY:-${SELF_IMPROVEMENT_UPSTREAM_REPOSITORY:-https://github.com/DH-stream/Codex-Self-Improvement-Skill.git}}"
  explicit_checkout="${UPSTREAM_LOCATION:-${SELF_IMPROVEMENT_UPSTREAM_CHECKOUT:-}}"
  checkout="${explicit_checkout:-$CODEX_HOME/self-improvement/upstream-checkout}"

  [[ -n "$repository" ]] || fail "upstream repository is empty"

  if [[ -n "$explicit_checkout" ]]; then
    has_repo_layout "$checkout" || fail "supplied upstream checkout is incomplete: $checkout"
  else
    command -v git >/dev/null 2>&1 || fail "git is required for streamed installation"
    mkdir -p "$(dirname "$checkout")"

    if [[ -d "$checkout/.git" ]]; then
      git -C "$checkout" fetch origin main || fail "could not fetch upstream main"
      git -C "$checkout" checkout main >/dev/null 2>&1 || fail "could not checkout upstream main"
      git -C "$checkout" pull --ff-only origin main || fail "upstream checkout is not fast-forwardable"
      has_repo_layout "$checkout" || fail "updated upstream checkout is incomplete: $checkout"
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
```

- [ ] **Step 3: Replace the current early initialization with this gate**

```bash
CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
[[ -n "$CODEX_HOME" && "$CODEX_HOME" != "/" ]] || fail "CODEX_HOME must be a non-root directory"

REPO_ROOT="$(resolve_script_root || true)"
if [[ -z "$REPO_ROOT" ]] || ! has_repo_layout "$REPO_ROOT"; then
  bootstrap_streamed_install
fi
```

Delete the duplicate existing `CODEX_HOME` and `REPO_ROOT` assignments. Keep the local installer body from `SKILL_SOURCE=...` onward unchanged.

- [ ] **Step 4: Run GREEN**

```bash
bash -n install.sh
bash tests/test-install.sh
```

Expected: syntax succeeds; seven tests pass.

- [ ] **Step 5: Commit**

```bash
git add install.sh tests/test-install.sh
git commit -m "feat: support streamed bash installation"
```

### Task 3: Add RED PowerShell streamed-install tests

**Files:**
- Create: `tests/test-install.ps1`

**Interfaces:**
- Produces: two isolated tests using a local bare Git remote and raw-text installer execution.

- [ ] **Step 1: Create `tests/test-install.ps1` with this content**

```powershell
$ErrorActionPreference = "Stop"
$root = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$tempRoot = Join-Path ([IO.Path]::GetTempPath()) ("codex-install-tests-" + [guid]::NewGuid().ToString("N"))
$shell = (Get-Process -Id $PID).Path
$passed = 0
$failed = 0

function Assert-Native([string]$Message) {
  if ($LASTEXITCODE -ne 0) { throw $Message }
}

function New-Fixture([string]$Path) {
  New-Item -ItemType Directory -Force -Path $Path | Out-Null
  Copy-Item (Join-Path $root "install.ps1") $Path
  Copy-Item (Join-Path $root "install") $Path -Recurse
  Copy-Item (Join-Path $root "memory") $Path -Recurse
  Copy-Item (Join-Path $root "skills") $Path -Recurse
}

function New-BareRemote([string]$Fixture, [string]$Bare) {
  & git -C $Fixture init -q
  Assert-Native "git init failed"
  & git -C $Fixture config user.email test@example.com
  & git -C $Fixture config user.name "Installer Test"
  & git -C $Fixture add .
  & git -C $Fixture commit -qm "test fixture"
  Assert-Native "git commit failed"
  & git clone -q --bare $Fixture $Bare
  Assert-Native "bare clone failed"
}

function Invoke-Streamed([string]$Home, [string]$Remote, [string]$Installer) {
  $runner = Join-Path $tempRoot ("runner-" + [guid]::NewGuid().ToString("N") + ".ps1")
  @'
param([string]$HomePath, [string]$RemotePath, [string]$InstallerPath)
$ErrorActionPreference = "Stop"
$env:CODEX_HOME = $HomePath
$env:UPSTREAM_REPOSITORY = $RemotePath
$source = Get-Content -Raw -LiteralPath $InstallerPath
Invoke-Expression $source
'@ | Set-Content -LiteralPath $runner -Encoding UTF8
  & $shell -NoProfile -File $runner $Home $Remote $Installer
  return $LASTEXITCODE
}

function Pass([string]$Name) {
  $script:passed++
  Write-Host "PASS: $Name"
}

function Fail([string]$Name, [string]$Reason) {
  $script:failed++
  Write-Error "FAIL: $Name — $Reason" -ErrorAction Continue
}

try {
  New-Item -ItemType Directory -Force -Path $tempRoot | Out-Null

  $fixture = Join-Path $tempRoot "success-fixture"
  $bare = Join-Path $tempRoot "success.git"
  $home = Join-Path $tempRoot "success-home"
  New-Fixture $fixture
  New-BareRemote $fixture $bare
  $code = Invoke-Streamed $home $bare (Join-Path $fixture "install.ps1")
  $checkout = Join-Path $home "self-improvement\upstream-checkout"
  if ($code -eq 0 -and
      (Test-Path (Join-Path $home "skills\codex-self-improvement\SKILL.md")) -and
      (Test-Path (Join-Path $checkout ".git"))) {
    Pass "streamed bootstrap installs from persistent checkout"
  } else {
    Fail "streamed bootstrap installs from persistent checkout" "installation or checkout missing"
  }

  $failureFixture = Join-Path $tempRoot "failure-fixture"
  $failureHome = Join-Path $tempRoot "failure-home"
  New-Fixture $failureFixture
  $sentinel = Join-Path $failureHome "skills\codex-self-improvement\sentinel.txt"
  New-Item -ItemType Directory -Force -Path (Split-Path $sentinel -Parent) | Out-Null
  Set-Content -LiteralPath $sentinel -Value "keep-me"
  $code = Invoke-Streamed $failureHome (Join-Path $tempRoot "missing.git") (Join-Path $failureFixture "install.ps1")
  if ($code -ne 0 -and (Test-Path $sentinel)) {
    Pass "streamed bootstrap failure preserves existing install"
  } else {
    Fail "streamed bootstrap failure preserves existing install" "invalid remote succeeded or sentinel disappeared"
  }

  Write-Host "`nInstaller tests: $passed passed, $failed failed"
  if ($failed -ne 0) { exit 1 }
} finally {
  Remove-Item -Recurse -Force -ErrorAction SilentlyContinue $tempRoot
}
```

- [ ] **Step 2: Run RED**

```powershell
./tests/test-install.ps1
```

Expected: streamed success fails before bootstrap implementation.

- [ ] **Step 3: Commit**

```bash
git add tests/test-install.ps1
git commit -m "test: cover streamed powershell installation"
```

### Task 4: Implement the PowerShell bootstrap

**Files:**
- Modify: `install.ps1`
- Test: `tests/test-install.ps1`

**Interfaces:**
- Consumes: installer parameters and matching environment variables.
- Produces: the same persistent-checkout contract as Bash.

- [ ] **Step 1: Add these functions after `Assert-File`**

```powershell
function Test-RepositoryLayout([string]$Root) {
  if ([string]::IsNullOrWhiteSpace($Root)) { return $false }
  return (Test-Path -LiteralPath (Join-Path $Root "install.ps1") -PathType Leaf) -and
    (Test-Path -LiteralPath (Join-Path $Root "skills\codex-self-improvement") -PathType Container) -and
    (Test-Path -LiteralPath (Join-Path $Root "memory\private-template") -PathType Container) -and
    (Test-Path -LiteralPath (Join-Path $Root "install\AGENTS-snippet.md") -PathType Leaf)
}

function Invoke-Git([string[]]$Arguments, [string]$FailureMessage) {
  & git @Arguments
  if ($LASTEXITCODE -ne 0) { throw $FailureMessage }
}

function Invoke-StreamedBootstrap {
  $codexFull = [IO.Path]::GetFullPath($CodexHome)
  if ($codexFull -eq [IO.Path]::GetPathRoot($codexFull)) {
    throw "CodexHome must be a non-root directory"
  }

  $repository = if ($PSBoundParameters.ContainsKey("UpstreamRepository")) {
    $UpstreamRepository
  } elseif (-not [string]::IsNullOrWhiteSpace($env:UPSTREAM_REPOSITORY)) {
    $env:UPSTREAM_REPOSITORY
  } elseif (-not [string]::IsNullOrWhiteSpace($env:SELF_IMPROVEMENT_UPSTREAM_REPOSITORY)) {
    $env:SELF_IMPROVEMENT_UPSTREAM_REPOSITORY
  } else {
    $UpstreamRepository
  }
  if ([string]::IsNullOrWhiteSpace($repository)) {
    throw "UpstreamRepository must not be empty"
  }

  $explicitCheckout = if ($PSBoundParameters.ContainsKey("UpstreamCheckout") -and -not [string]::IsNullOrWhiteSpace($UpstreamCheckout)) {
    $UpstreamCheckout
  } elseif (-not [string]::IsNullOrWhiteSpace($env:UPSTREAM_LOCATION)) {
    $env:UPSTREAM_LOCATION
  } elseif (-not [string]::IsNullOrWhiteSpace($env:SELF_IMPROVEMENT_UPSTREAM_CHECKOUT)) {
    $env:SELF_IMPROVEMENT_UPSTREAM_CHECKOUT
  } else {
    ""
  }

  $checkout = if ([string]::IsNullOrWhiteSpace($explicitCheckout)) {
    Join-Path $codexFull "self-improvement\upstream-checkout"
  } else {
    [IO.Path]::GetFullPath($explicitCheckout)
  }
  $tempCheckout = ""

  try {
    if (-not [string]::IsNullOrWhiteSpace($explicitCheckout)) {
      if (-not (Test-RepositoryLayout $checkout)) {
        throw "Supplied upstream checkout is incomplete: $checkout"
      }
    } else {
      if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
        throw "git is required for streamed installation"
      }
      New-Item -ItemType Directory -Force -Path (Split-Path $checkout -Parent) | Out-Null

      if (Test-Path -LiteralPath (Join-Path $checkout ".git") -PathType Container) {
        Invoke-Git @("-C", $checkout, "fetch", "origin", "main") "Could not fetch upstream main"
        Invoke-Git @("-C", $checkout, "checkout", "main") "Could not checkout upstream main"
        Invoke-Git @("-C", $checkout, "pull", "--ff-only", "origin", "main") "Upstream checkout is not fast-forwardable"
        if (-not (Test-RepositoryLayout $checkout)) {
          throw "Updated upstream checkout is incomplete: $checkout"
        }
      } elseif (Test-Path -LiteralPath $checkout) {
        throw "Managed upstream checkout exists but is not a Git repository: $checkout"
      } else {
        $tempCheckout = "$checkout.install-$([guid]::NewGuid().ToString('N'))"
        Invoke-Git @("clone", "--quiet", "--branch", "main", "--single-branch", $repository, $tempCheckout) "Could not clone upstream repository"
        if (-not (Test-RepositoryLayout $tempCheckout)) {
          throw "Cloned upstream checkout is incomplete"
        }
        Move-Item -LiteralPath $tempCheckout -Destination $checkout
        $tempCheckout = ""
      }
    }

    $installerPath = Join-Path $checkout "install.ps1"
    & $installerPath -CodexHome $CodexHome -UpstreamCheckout $checkout -UpstreamRepository $repository
  } finally {
    if (-not [string]::IsNullOrWhiteSpace($tempCheckout)) {
      Remove-Item -Recurse -Force -ErrorAction SilentlyContinue $tempCheckout
    }
  }
}
```

- [ ] **Step 2: Replace the unsafe repo-root assignment with this gate**

```powershell
$scriptPath = $MyInvocation.MyCommand.Path
$repoRoot = if (-not [string]::IsNullOrWhiteSpace($scriptPath)) {
  Split-Path -Parent $scriptPath
} else {
  ""
}
if (-not (Test-RepositoryLayout $repoRoot)) {
  Invoke-StreamedBootstrap
  return
}
```

Keep the existing local installer body from `$skillSource = ...` onward unchanged.

- [ ] **Step 3: Run GREEN**

```powershell
./tests/test-install.ps1
```

```bash
bash -n install.sh
bash tests/test-install.sh
```

Expected: both PowerShell tests pass where PowerShell is available; all seven Bash tests pass.

- [ ] **Step 4: Commit**

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

- [ ] **Step 1: Run all available tests**

```bash
bash -n install.sh
bash tests/test-install.sh
```

```powershell
./tests/test-install.ps1
```

- [ ] **Step 2: Inspect actual code against current `main`**

```bash
git diff --check main...HEAD
git diff main...HEAD -- install.sh install.ps1 tests/test-install.sh tests/test-install.ps1
```

Confirm no active-install path is touched before streamed checkout validation succeeds.

- [ ] **Step 3: Commit review fixes only when needed**

```bash
git add install.sh install.ps1 tests/test-install.sh tests/test-install.ps1
git commit -m "fix: harden streamed installer bootstrap"
```
