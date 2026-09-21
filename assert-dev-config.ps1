[CmdletBinding()]
param(
    [string]$ConfigHome = "D:\C2D\dotfiles\komorebi-dev"
)

$ErrorActionPreference = "Stop"
$expectedRole = "komorebi-fork"
$markerPath = Join-Path $ConfigHome ".komorebi-config-role"

if (-not (Test-Path -LiteralPath $ConfigHome -PathType Container)) {
    throw "Missing Komorebi fork config directory: $ConfigHome"
}

if (-not (Test-Path -LiteralPath $markerPath -PathType Leaf)) {
    throw "Missing Komorebi config role marker: $markerPath"
}

$actualRole = (Get-Content -LiteralPath $markerPath -Raw).Trim()
if ($actualRole -ne $expectedRole) {
    throw "Refusing to start komorebi-fork with config role '$actualRole' from $ConfigHome; expected '$expectedRole'."
}

foreach ($requiredFile in @("komorebi.json", "applications.json")) {
    $requiredPath = Join-Path $ConfigHome $requiredFile
    if (-not (Test-Path -LiteralPath $requiredPath -PathType Leaf)) {
        throw "Missing required Komorebi fork config file: $requiredPath"
    }
}

(Resolve-Path -LiteralPath $ConfigHome).Path
