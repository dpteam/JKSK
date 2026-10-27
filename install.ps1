#Requires -Version 5.1
<#
.SYNOPSIS
    Installs the meme-joker skill for OpenCode.

.EXAMPLE
    .\install.ps1                 # English skill, global
    .\install.ps1 -Lang ru        # Russian skill
    .\install.ps1 -Lang all       # all three languages
    .\install.ps1 -Lang ru -Always  # also wire it into global instructions
#>
[CmdletBinding()]
param(
    [ValidateSet('en', 'ru', 'lt', 'all')]
    [string]$Lang = 'en',

    [switch]$Always
)

$ErrorActionPreference = 'Stop'

$root      = if ($PSScriptRoot) { $PSScriptRoot } else { (Get-Location).Path }
$configDir = Join-Path $HOME '.config/opencode'
$skillsDir = Join-Path $configDir 'skills'
$instrDir  = Join-Path $configDir 'instructions'

$map = [ordered]@{
    en = 'meme-joker'
    ru = 'meme-joker-ru'
    lt = 'meme-joker-lt'
}

$targets = if ($Lang -eq 'all') { @($map.Values) } else { @($map[$Lang]) }

Write-Host ''
Write-Host '  meme-joker :: installing' -ForegroundColor Magenta
Write-Host ''

New-Item -ItemType Directory -Force -Path $skillsDir | Out-Null

foreach ($name in $targets) {
    $src = Join-Path $root "skills/$name"
    if (-not (Test-Path $src)) {
        throw "Skill folder not found: $src"
    }
    $dst = Join-Path $skillsDir $name
    if (Test-Path $dst) { Remove-Item -Recurse -Force $dst }
    Copy-Item -Recurse -Force $src $skillsDir
    Write-Host "  [ok] $name" -ForegroundColor Green
}

if (-not $Always) {
    Write-Host ''
    Write-Host '  Installed. Load it with @meme-joker or just ask to "be funny".' -ForegroundColor DarkGray
    Write-Host '  Want it always on? Re-run with -Always.' -ForegroundColor DarkGray
    Write-Host ''
    return
}

# --- always-on wiring -------------------------------------------------------

New-Item -ItemType Directory -Force -Path $instrDir | Out-Null

$instrSrc = Join-Path $root 'instructions/meme-joker.md'
if (Test-Path $instrSrc) {
    Copy-Item -Force $instrSrc $instrDir
    Write-Host '  [ok] instructions/meme-joker.md' -ForegroundColor Green
}
else {
    Write-Host '  [skip] instructions/meme-joker.md not found in repo' -ForegroundColor Yellow
}

$configFile = @(
    (Join-Path $configDir 'opencode.jsonc'),
    (Join-Path $configDir 'opencode.json')
) | Where-Object { Test-Path $_ } | Select-Object -First 1

if (-not $configFile) {
    Write-Host ''
    Write-Host '  No global opencode.json found. Add this manually:' -ForegroundColor Yellow
    Write-Host '    "instructions": ["~/.config/opencode/instructions/meme-joker.md"]' -ForegroundColor Yellow
    Write-Host ''
    return
}

$raw = Get-Content -Path $configFile -Raw

if ($raw -match '"instructions"\s*:') {
    Write-Host '  [skip] config already has "instructions" — add the path yourself:' -ForegroundColor Yellow
    Write-Host '    ~/.config/opencode/instructions/meme-joker.md' -ForegroundColor Yellow
    Write-Host ''
    return
}

$entry = '  "instructions": ["~/.config/opencode/instructions/meme-joker.md"],'

if ($raw -notmatch '(?m)^(\s*"\$schema"\s*:\s*"[^"]*")\s*(,?)') {
    Write-Host '  [skip] could not find "$schema" to anchor the edit. Add manually:' -ForegroundColor Yellow
    Write-Host "    $entry" -ForegroundColor Yellow
    Write-Host ''
    return
}

$backup = "$configFile.bak-meme-joker"
Copy-Item -Path $configFile -Destination $backup -Force

function Test-JsonFile([string]$Path) {
    try { $null = Get-Content -Path $Path -Raw | ConvertFrom-Json; return $true }
    catch { return $false }
}

$originalWasValid = Test-JsonFile $backup

$updated = [regex]::Replace(
    $raw,
    '(?m)^(\s*"\$schema"\s*:\s*"[^"]*")\s*(,?)',
    "`$1,`r`n$entry",
    1
)

Set-Content -Path $configFile -Value $updated -Encoding UTF8

if (-not $originalWasValid) {
    Write-Host "  [ok] instructions wired into $configFile" -ForegroundColor Green
    Write-Host "  [warn] the config was not strict JSON to begin with, so the edit was not verified." -ForegroundColor Yellow
    Write-Host "  backup: $backup" -ForegroundColor DarkGray
}
elseif (Test-JsonFile $configFile) {
    Write-Host "  [ok] instructions wired into $configFile" -ForegroundColor Green
    Write-Host "  backup: $backup" -ForegroundColor DarkGray
}
else {
    Copy-Item -Path $backup -Destination $configFile -Force
    Write-Host '  [warn] config did not parse after the edit — reverted.' -ForegroundColor Red
    Write-Host '  Add this line manually:' -ForegroundColor Yellow
    Write-Host "    $entry" -ForegroundColor Yellow
}

Write-Host ''
Write-Host '  Done. Go say something unhinged to your terminal.' -ForegroundColor Magenta
Write-Host ''
