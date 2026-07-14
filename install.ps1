param(
  [string]$CodexHome = (Join-Path $HOME ".codex"),
  [string]$UpstreamCheckout = "",
  [string]$UpstreamRepository = "https://github.com/DH-stream/Codex-Self-Improvement-Skill.git"
)

$ErrorActionPreference = "Stop"
$repoRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$skillSource = Join-Path $repoRoot "skills\codex-self-improvement"
$skillTarget = Join-Path $CodexHome "skills\codex-self-improvement"
$memorySource = Join-Path $repoRoot "memory"
$privateTemplate = Join-Path $memorySource "private-template"
$stateRoot = Join-Path $CodexHome "self-improvement"
$universalTarget = Join-Path $stateRoot "universal"
$privateTarget = Join-Path $stateRoot "private"
$legacyMemory = Join-Path $stateRoot "memory"
$resolvedUpstreamCheckout = if ([string]::IsNullOrWhiteSpace($UpstreamCheckout)) { $repoRoot } else { $UpstreamCheckout }
$agentsPath = Join-Path $CodexHome "AGENTS.md"
$snippetPath = Join-Path $repoRoot "install\AGENTS-snippet.md"

if (Test-Path $skillTarget) {
  Remove-Item -Recurse -Force $skillTarget
}
New-Item -ItemType Directory -Force -Path $skillTarget | Out-Null
Copy-Item -Path (Join-Path $skillSource "*") -Destination $skillTarget -Recurse -Force

if (Test-Path $universalTarget) {
  Remove-Item -Recurse -Force $universalTarget
}
New-Item -ItemType Directory -Force -Path $universalTarget | Out-Null
Get-ChildItem -Path $memorySource -File | ForEach-Object {
  Copy-Item $_.FullName (Join-Path $universalTarget $_.Name) -Force
}

New-Item -ItemType Directory -Force -Path $privateTarget | Out-Null

# Preserve taste learned by the first installer layout before applying templates.
@("UX_TASTE.md", "UX_TASTE_HISTORY.md") | ForEach-Object {
  $legacy = Join-Path $legacyMemory $_
  $destination = Join-Path $privateTarget $_
  if ((Test-Path $legacy) -and -not (Test-Path $destination)) {
    Copy-Item $legacy $destination
  }
}

# Private state is seeded once and is never overwritten by reinstall or sync.
Get-ChildItem -Path $privateTemplate -File | ForEach-Object {
  $destination = Join-Path $privateTarget $_.Name
  if (-not (Test-Path $destination)) {
    Copy-Item $_.FullName $destination
  }
}

New-Item -ItemType Directory -Force -Path $stateRoot | Out-Null
Set-Content -Path (Join-Path $stateRoot "PRIVATE_LOCATION") -Value $privateTarget -Encoding UTF8
Set-Content -Path (Join-Path $stateRoot "UNIVERSAL_LOCATION") -Value $universalTarget -Encoding UTF8
Set-Content -Path (Join-Path $stateRoot "UPSTREAM_LOCATION") -Value $resolvedUpstreamCheckout -Encoding UTF8
Set-Content -Path (Join-Path $stateRoot "UPSTREAM_REPOSITORY") -Value $UpstreamRepository -Encoding UTF8

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
Write-Host "Universal memory: $universalTarget"
Write-Host "Private memory: $privateTarget"
Write-Host "Upstream checkout: $resolvedUpstreamCheckout"
Write-Host "Updated global hook: $agentsPath"
