[CmdletBinding()]
param(
    [switch]$DebugBuild,
    [switch]$NoBar
)

$ErrorActionPreference = "Stop"
$repoRoot = $PSScriptRoot
$configGuard = Join-Path $repoRoot "assert-dev-config.ps1"
$configHome = & $configGuard

$buildProfile = if ($DebugBuild) { "debug" } else { "release" }
$binDir = Join-Path $repoRoot "target\$buildProfile"
$komorebiExe = Join-Path $binDir "komorebi.exe"

if (-not (Test-Path -LiteralPath $komorebiExe)) {
    throw "Binary not found: $komorebiExe. Run build-dev.ps1 first."
}

$env:KOMOREBI_DEV_BIN_DIR = $binDir
$configJson = Join-Path $configHome "komorebi.json"

Write-Host "Starting Komorebi Dev ($buildProfile)..."
Start-Process -FilePath $komorebiExe -ArgumentList @("--config", $configJson) -WindowStyle Hidden
