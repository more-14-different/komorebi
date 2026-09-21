[CmdletBinding()]
param(
    [switch]$NoBuild,
    [switch]$DebugBuild,
    [switch]$CleanState,
    [switch]$NoBar
)

$ErrorActionPreference = "Stop"

$repoRoot = $PSScriptRoot
$configGuard = Join-Path $repoRoot "assert-dev-config.ps1"
$configHome = & $configGuard

if (-not $NoBuild) {
    $buildScript = Join-Path $repoRoot "build-dev.ps1"
    & $buildScript -DebugBuild:$DebugBuild
}

$buildProfile = if ($DebugBuild) { "debug" } else { "release" }
$env:KOMOREBI_DEV_BIN_DIR = Join-Path $repoRoot "target\$buildProfile"
$env:KOMOREBI_CONFIG_HOME = $configHome

$restartScript = if ($CleanState) {
    Join-Path $configHome "run-komorebi-clean.ps1"
} else {
    Join-Path $configHome "run-komorebi-dumped-session.ps1"
}

Write-Host "Restarting Komorebi Dev ($buildProfile) via $restartScript..."
& powershell.exe -NoProfile -ExecutionPolicy Bypass -File $restartScript $(if ($NoBar) { "-NoBar" })
