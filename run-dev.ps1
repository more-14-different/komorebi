[CmdletBinding()]
param(
    [switch]$DebugBuild,
    [string]$LogLevel = "info"
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

$configJson = Join-Path $configHome "komorebi.json"
$env:KOMOREBI_DEV_BIN_DIR = $binDir
$env:RUST_LOG = $LogLevel

Write-Host "Running Komorebi Dev in console ($buildProfile, log=$LogLevel)..."
& $komorebiExe --config $configJson --log-level $LogLevel
