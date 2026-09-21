[CmdletBinding()]
param(
    [switch]$DebugBuild,
    [switch]$CleanState,
    [switch]$NoBar
)

$ErrorActionPreference = "Stop"
$repoRoot = $PSScriptRoot
$restartScript = Join-Path $repoRoot "restart-dev-dist.ps1"

& powershell.exe -NoProfile -ExecutionPolicy Bypass -File $restartScript $(if ($DebugBuild) { "-DebugBuild" }) $(if ($CleanState) { "-CleanState" }) $(if ($NoBar) { "-NoBar" })
