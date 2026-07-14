param(
  [string]$CodexHome = (Join-Path $HOME ".codex"),
  [string]$UpstreamCheckout = "",
  [string]$UpstreamRepository = "https://github.com/DH-stream/Codex-Self-Improvement-Skill.git"
)

$ErrorActionPreference = "Stop"

function Assert-Directory([string]$Path, [string]$Label) {
  if (-not (Test-Path -LiteralPath $Path -PathType Container)) {
    throw "Missing ${Label}: $Path"
  }
}

function Assert-File([string]$Path, [string]$Label) {
  if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
    throw "Missing ${Label}: $Path"
  }
}

$repoRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$skillSource = Join-Path $repoRoot "skills\codex-self-improvement"
$memorySource = Join-Path $repoRoot "memory"
$privateTemplate = Join-Path $memorySource "private-template"
$snippetPath = Join-Path $repoRoot "install\AGENTS-snippet.md"

Assert-Directory $skillSource "skill source"
Assert-Directory $memorySource "memory source"
Assert-Directory $privateTemplate "private template"
Assert-File $snippetPath "activation snippet"

$codexFull = [IO.Path]::GetFullPath($CodexHome)
if ($codexFull -eq [IO.Path]::GetPathRoot($codexFull)) {
  throw "CodexHome must be a non-root directory"
}

$checkoutCandidate = if ($PSBoundParameters.ContainsKey("UpstreamCheckout") -and -not [string]::IsNullOrWhiteSpace($UpstreamCheckout)) {
  $UpstreamCheckout
} elseif (-not [string]::IsNullOrWhiteSpace($env:UPSTREAM_LOCATION)) {
  $env:UPSTREAM_LOCATION
} elseif (-not [string]::IsNullOrWhiteSpace($env:SELF_IMPROVEMENT_UPSTREAM_CHECKOUT)) {
  $env:SELF_IMPROVEMENT_UPSTREAM_CHECKOUT
} else {
  $repoRoot
}
Assert-Directory $checkoutCandidate "upstream checkout"
$resolvedUpstreamCheckout = (Resolve-Path -LiteralPath $checkoutCandidate).Path

$resolvedUpstreamRepository = if ($PSBoundParameters.ContainsKey("UpstreamRepository")) {
  $UpstreamRepository
} elseif (-not [string]::IsNullOrWhiteSpace($env:UPSTREAM_REPOSITORY)) {
  $env:UPSTREAM_REPOSITORY
} elseif (-not [string]::IsNullOrWhiteSpace($env:SELF_IMPROVEMENT_UPSTREAM_REPOSITORY)) {
  $env:SELF_IMPROVEMENT_UPSTREAM_REPOSITORY
} else {
  $UpstreamRepository
}
if ([string]::IsNullOrWhiteSpace($resolvedUpstreamRepository)) {
  throw "UpstreamRepository must not be empty"
}

New-Item -ItemType Directory -Force -Path $codexFull | Out-Null
$skillsRoot = Join-Path $codexFull "skills"
$stateRoot = Join-Path $codexFull "self-improvement"
$skillTarget = Join-Path $skillsRoot "codex-self-improvement"
$universalTarget = Join-Path $stateRoot "universal"
$privateTarget = Join-Path $stateRoot "private"
$legacyMemory = Join-Path $stateRoot "memory"
$agentsPath = Join-Path $codexFull "AGENTS.md"

New-Item -ItemType Directory -Force -Path $skillsRoot, $stateRoot, $privateTarget | Out-Null
$stageRoot = Join-Path $stateRoot (".install-" + [guid]::NewGuid().ToString("N"))
$skillStage = Join-Path $stageRoot "skill"
$universalStage = Join-Path $stageRoot "universal"
$agentsStage = Join-Path $stageRoot "AGENTS.md"
New-Item -ItemType Directory -Force -Path $skillStage, $universalStage | Out-Null

try {
  Get-ChildItem -LiteralPath $skillSource -Force | ForEach-Object {
    Copy-Item -LiteralPath $_.FullName -Destination $skillStage -Recurse -Force
  }
  Get-ChildItem -LiteralPath $memorySource -File -Force | ForEach-Object {
    Copy-Item -LiteralPath $_.FullName -Destination (Join-Path $universalStage $_.Name) -Force
  }

  $snippet = (Get-Content -Raw -LiteralPath $snippetPath).Trim()
  $agents = if (Test-Path -LiteralPath $agentsPath) { Get-Content -Raw -LiteralPath $agentsPath } else { "" }
  $start = "<!-- codex-self-improvement:start -->"
  $end = "<!-- codex-self-improvement:end -->"
  $lines = if ($agents.Length -gt 0) { [regex]::Split($agents, "\r?\n") } else { @() }
  $startCount = @($lines | Where-Object { $_ -eq $start }).Count
  $endCount = @($lines | Where-Object { $_ -eq $end }).Count
  if ($startCount -ne $endCount) {
    throw "AGENTS.md has unmatched self-improvement markers"
  }

  $output = New-Object 'System.Collections.Generic.List[string]'
  $snippetLines = [regex]::Split($snippet, "\r?\n")
  $inBlock = $false
  $emitted = $false
  foreach ($line in $lines) {
    if ($line -eq $start) {
      if (-not $emitted) {
        foreach ($snippetLine in $snippetLines) { $output.Add($snippetLine) }
      }
      $emitted = $true
      $inBlock = $true
      continue
    }
    if ($inBlock) {
      if ($line -eq $end) { $inBlock = $false }
      continue
    }
    $output.Add($line)
  }
  if (-not $emitted) {
    if ($output.Count -gt 0) { $output.Add("") }
    foreach ($snippetLine in $snippetLines) { $output.Add($snippetLine) }
  }

  $updatedAgents = (($output -join [Environment]::NewLine).TrimEnd() + [Environment]::NewLine)
  $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
  [IO.File]::WriteAllText($agentsStage, $updatedAgents, $utf8NoBom)

  $generated = Get-Content -Raw -LiteralPath $agentsStage
  if (([regex]::Matches($generated, [regex]::Escape($start))).Count -ne 1 -or
      ([regex]::Matches($generated, [regex]::Escape($end))).Count -ne 1) {
    throw "Generated AGENTS.md has invalid activation markers"
  }

  # Preserve taste learned by the first installer layout before applying templates.
  @("UX_TASTE.md", "UX_TASTE_HISTORY.md") | ForEach-Object {
    $legacy = Join-Path $legacyMemory $_
    $destination = Join-Path $privateTarget $_
    if ((Test-Path -LiteralPath $legacy) -and -not (Test-Path -LiteralPath $destination)) {
      Copy-Item -LiteralPath $legacy -Destination $destination
    }
  }

  # Private state is seeded once and never overwritten by reinstall or sync.
  Get-ChildItem -LiteralPath $privateTemplate -File -Force | ForEach-Object {
    $destination = Join-Path $privateTarget $_.Name
    if (-not (Test-Path -LiteralPath $destination)) {
      Copy-Item -LiteralPath $_.FullName -Destination $destination
    }
  }

  $skillBackup = Join-Path $stageRoot "skill.backup"
  $universalBackup = Join-Path $stageRoot "universal.backup"
  $agentsBackup = Join-Path $stageRoot "AGENTS.backup"
  $agentsExisted = Test-Path -LiteralPath $agentsPath
  if ($agentsExisted) { Copy-Item -LiteralPath $agentsPath -Destination $agentsBackup }

  try {
    if (Test-Path -LiteralPath $skillTarget) { Move-Item -LiteralPath $skillTarget -Destination $skillBackup }
    if (Test-Path -LiteralPath $universalTarget) { Move-Item -LiteralPath $universalTarget -Destination $universalBackup }
    Move-Item -LiteralPath $skillStage -Destination $skillTarget
    Move-Item -LiteralPath $universalStage -Destination $universalTarget
    Copy-Item -LiteralPath $agentsStage -Destination $agentsPath -Force

    Set-Content -LiteralPath (Join-Path $stateRoot "PRIVATE_LOCATION") -Value $privateTarget -Encoding UTF8
    Set-Content -LiteralPath (Join-Path $stateRoot "UNIVERSAL_LOCATION") -Value $universalTarget -Encoding UTF8
    Set-Content -LiteralPath (Join-Path $stateRoot "UPSTREAM_LOCATION") -Value $resolvedUpstreamCheckout -Encoding UTF8
    Set-Content -LiteralPath (Join-Path $stateRoot "UPSTREAM_REPOSITORY") -Value $resolvedUpstreamRepository -Encoding UTF8

    Remove-Item -Recurse -Force -ErrorAction SilentlyContinue $skillBackup, $universalBackup
  } catch {
    Remove-Item -Recurse -Force -ErrorAction SilentlyContinue $skillTarget, $universalTarget
    if (Test-Path -LiteralPath $skillBackup) { Move-Item -LiteralPath $skillBackup -Destination $skillTarget }
    if (Test-Path -LiteralPath $universalBackup) { Move-Item -LiteralPath $universalBackup -Destination $universalTarget }
    if ($agentsExisted) {
      Copy-Item -LiteralPath $agentsBackup -Destination $agentsPath -Force
    } else {
      Remove-Item -Force -ErrorAction SilentlyContinue $agentsPath
    }
    throw
  }
} finally {
  Remove-Item -Recurse -Force -ErrorAction SilentlyContinue $stageRoot
}

Write-Host "Installed skill: $skillTarget"
Write-Host "Universal snapshot: $universalTarget"
Write-Host "Private memory: $privateTarget"
Write-Host "Upstream checkout: $resolvedUpstreamCheckout"
Write-Host "Updated global hook: $agentsPath"