[CmdletBinding()]
param(
    [switch]$DebugBuild
)

$ErrorActionPreference = "Stop"
$repoRoot = $PSScriptRoot

$buildProfile = if ($DebugBuild) { "debug" } else { "release" }
$targetDir = Join-Path $repoRoot "target\$buildProfile"

# Stop running dev instances if their executables are in targetDir to prevent file locks
$devKomorebiExe = Join-Path $targetDir "komorebi.exe"
if (Test-Path -LiteralPath $devKomorebiExe) {
    Get-Process komorebi -ErrorAction SilentlyContinue |
        Where-Object { $_.Path -eq $devKomorebiExe } |
        Stop-Process -Force
}

Push-Location $repoRoot
try {
    Write-Host "Building komorebi & komorebic ($buildProfile)..."
    if ($DebugBuild) {
        cargo build -p komorebi -p komorebic
    } else {
        cargo build --release -p komorebi -p komorebic
    }
    if ($LASTEXITCODE -ne 0) {
        throw "Cargo build failed with exit code $LASTEXITCODE"
    }
    Write-Host "Build complete: $targetDir"
}
finally {
    Pop-Location
}
