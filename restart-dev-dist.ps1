[CmdletBinding()]
param(
    [switch]$NoBuild,
    [switch]$DebugBuild,
    [switch]$CleanState,
    [switch]$NoBar,
    [switch]$Rebuild
)

$ErrorActionPreference = "Stop"

$repoRoot = $PSScriptRoot
$configGuard = Join-Path $repoRoot "assert-dev-config.ps1"
$configHome = & $configGuard

$buildProfile = if ($DebugBuild) { "debug" } else { "release" }
$binDir = Join-Path $repoRoot "target\$buildProfile"
$komorebiExe = Join-Path $binDir "komorebi.exe"
$komorebicExe = Join-Path $binDir "komorebic.exe"

$needBuild = $false
if ($DebugBuild -or $Rebuild) {
    # Debug: 无条件强制重新编译 (除非显式 -NoBuild)
    $needBuild = -not $NoBuild
} else {
    # Release: 仅在缺失时自动 build，不缺失时纯启动/纯重启
    $binariesExist = (Test-Path -LiteralPath $komorebiExe) -and (Test-Path -LiteralPath $komorebicExe)
    if (-not $binariesExist) {
        $needBuild = -not $NoBuild
    }
}

if ($needBuild) {
    $buildScript = Join-Path $repoRoot "build-dev.ps1"
    & $buildScript -DebugBuild:$DebugBuild
}

$env:KOMOREBI_DEV_BUILD = $buildProfile
$env:KOMOREBI_DEV_BIN_DIR = $binDir
$env:KOMOREBI_CONFIG_HOME = $configHome

$restartScript = if ($CleanState) {
    Join-Path $configHome "run-komorebi-clean.ps1"
} else {
    Join-Path $configHome "run-komorebi-dumped-session.ps1"
}

$restartArgs = @("-NoProfile", "-ExecutionPolicy", "Bypass", "-File", $restartScript)
if ($DebugBuild) {
    $restartArgs += "-DebugBuild"
}
if ($NoBar) {
    $restartArgs += "-NoBar"
}

Write-Host "Restarting Komorebi Dev ($buildProfile) via $restartScript..."
& powershell.exe @restartArgs
