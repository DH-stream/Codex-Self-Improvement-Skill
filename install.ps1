param(
  [string]$CodexHome = (Join-Path $HOME ".codex"),
  [switch]$UseRepositoryMemory
)

$ErrorActionPreference = "Stop"
$repoRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$skillSource = Join-Path $repoRoot "skills\codex-self-improvement"
$skillTarget = Join-Path $CodexHome "skills\codex-self-improvement"
$seedMemory = Join-Path $repoRoot "memory"
$stateRoot = Join-Path $CodexHome "self-improvement"
$localMemory = Join-Path $stateRoot "memory"
$memoryTarget = if ($UseRepositoryMemory) { $seedMemory } else { $localMemory }
$agentsPath = Join-Path $CodexHome "AGENTS.md"
$snippetPath = Join-Path $repoRoot "install\AGENTS-snippet.md"

New-Item -ItemType Directory -Force -Path $skillTarget | Out-Null
Copy-Item -Path (Join-Path $skillSource "*") -Destination $skillTarget -Recurse -Force

New-Item -ItemType Directory -Force -Path $memoryTarget | Out-Null
if (-not $UseRepositoryMemory) {
  Get-ChildItem -Path $seedMemory -File | ForEach-Object {
    $destination = Join-Path $memoryTarget $_.Name
    if (-not (Test-Path $destination)) {
      Copy-Item $_.FullName $destination
    }
  }
}

New-Item -ItemType Directory -Force -Path $stateRoot | Out-Null
Set-Content -Path (Join-Path $stateRoot "LOCATION") -Value $memoryTarget -Encoding UTF8

$snippet = Get-Content -Raw -Path $snippetPath
$agents = if (Test-Path $agentsPath) { Get-Content -Raw -Path $agentsPath } else { "" }
$start = "<!-- codex-self-improvement:start -->"
$end = "<!-- codex-self-improvement:end -->"
$pattern = "(?s)" + [regex]::Escape($start) + ".*?" + [regex]::Escape($end)

if ($agents -match $pattern) {
  $agents = [regex]::Replace($agents, $pattern, $snippet.Trim())
} else {
  $agents = ($agents.TrimEnd() + "`r`n`r`n" + $snippet.Trim() + "`r`n").TrimStart()
}
Set-Content -Path $agentsPath -Value $agents -Encoding UTF8

Write-Host "Installed skill: $skillTarget"
Write-Host "Persistent memory: $memoryTarget"
Write-Host "Updated global hook: $agentsPath"
