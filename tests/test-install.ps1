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
  & git -C $Fixture branch -M main
  Assert-Native "git branch rename failed"
  & git clone -q --bare $Fixture $Bare
  Assert-Native "bare clone failed"
}

function Invoke-Streamed([string]$Home, [string]$Remote, [string]$Installer) {
  $runner = Join-Path $tempRoot ("runner-" + [guid]::NewGuid().ToString("N") + ".ps1")
  $runnerSource = @'
param([string]$HomePath, [string]$RemotePath, [string]$InstallerPath)
$ErrorActionPreference = "Stop"
$env:CODEX_HOME = $HomePath
$env:UPSTREAM_REPOSITORY = $RemotePath
$source = Get-Content -Raw -LiteralPath $InstallerPath
Invoke-Expression $source
'@
  Set-Content -LiteralPath $runner -Value $runnerSource -Encoding UTF8

  & $shell -NoProfile -File $runner $Home $Remote $Installer | Out-Host
  $exitCode = $LASTEXITCODE
  return $exitCode
}

function Pass([string]$Name) {
  $script:passed++
  Write-Host "PASS: $Name"
}

function Fail([string]$Name, [string]$Reason) {
  $script:failed++
  Write-Error "FAIL: $Name - $Reason" -ErrorAction Continue
}

function Test-StreamedBootstrapInstall {
  $name = "streamed bootstrap installs from persistent checkout"
  $fixture = Join-Path $tempRoot "fixture-success"
  $home = Join-Path $tempRoot "home-success"
  $bare = Join-Path $tempRoot "remote-success.git"
  New-Fixture $fixture
  New-BareRemote $fixture $bare

  $exitCode = Invoke-Streamed $home $bare (Join-Path $fixture "install.ps1")
  $checkout = if (Test-Path (Join-Path $home "self-improvement\UPSTREAM_LOCATION")) {
    (Get-Content -Raw (Join-Path $home "self-improvement\UPSTREAM_LOCATION")).Trim()
  } else { "" }

  if ($exitCode -eq 0 -and
      -not [string]::IsNullOrWhiteSpace($checkout) -and
      (Test-Path (Join-Path $home "skills\codex-self-improvement\SKILL.md")) -and
      (Test-Path (Join-Path $checkout ".git"))) {
    Pass $name
  } else {
    Fail $name "skill or persistent checkout missing"
  }
}

function Test-StreamedFailurePreservesInstall {
  $name = "streamed bootstrap failure preserves existing install"
  $fixture = Join-Path $tempRoot "fixture-failure"
  $home = Join-Path $tempRoot "home-failure"
  $sentinel = Join-Path $home "skills\codex-self-improvement\sentinel.txt"
  New-Fixture $fixture
  New-Item -ItemType Directory -Force -Path (Split-Path -Parent $sentinel) | Out-Null
  Set-Content -LiteralPath $sentinel -Value "keep-me"

  $exitCode = Invoke-Streamed $home (Join-Path $tempRoot "missing.git") (Join-Path $fixture "install.ps1")
  if ($exitCode -ne 0 -and (Test-Path $sentinel)) {
    Pass $name
  } else {
    Fail $name "invalid remote succeeded or active install changed"
  }
}

function Test-RepositoryOverrideRetargetsCheckout {
  $name = "streamed repository override retargets managed checkout"
  $fixtureA = Join-Path $tempRoot "fixture-origin-a"
  $fixtureB = Join-Path $tempRoot "fixture-origin-b"
  $home = Join-Path $tempRoot "home-origin"
  $bareA = Join-Path $tempRoot "remote-origin-a.git"
  $bareB = Join-Path $tempRoot "remote-origin-b.git"
  New-Fixture $fixtureA
  New-BareRemote $fixtureA $bareA

  $firstExit = Invoke-Streamed $home $bareA (Join-Path $fixtureA "install.ps1")
  if ($firstExit -ne 0) {
    Fail $name "initial streamed install failed"
    return
  }

  New-Fixture $fixtureB
  Add-Content -LiteralPath (Join-Path $fixtureB "memory\ACTIVE_PATTERNS.md") -Value "`nrepository-override-marker"
  New-BareRemote $fixtureB $bareB

  $secondExit = Invoke-Streamed $home $bareB (Join-Path $fixtureB "install.ps1")
  $checkout = Join-Path $home "self-improvement\upstream-checkout"
  $universal = Join-Path $home "self-improvement\universal\ACTIVE_PATTERNS.md"
  $origin = if (Test-Path $checkout) {
    (& git -C $checkout remote get-url origin | Out-String).Trim()
  } else { "" }

  if ($secondExit -eq 0 -and
      (Select-String -LiteralPath $universal -SimpleMatch "repository-override-marker" -Quiet) -and
      $origin -eq $bareB) {
    Pass $name
  } else {
    Fail $name "managed checkout kept the previous origin"
  }
}

try {
  New-Item -ItemType Directory -Force -Path $tempRoot | Out-Null
  Test-StreamedBootstrapInstall
  Test-StreamedFailurePreservesInstall
  Test-RepositoryOverrideRetargetsCheckout
} finally {
  Remove-Item -Recurse -Force -ErrorAction SilentlyContinue $tempRoot
}

Write-Host "`nInstaller tests: $passed passed, $failed failed"
if ($failed -ne 0) { exit 1 }
