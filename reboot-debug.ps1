<#
.SYNOPSIS
    重启 (Kill 并 Boot) komorebi dev debug 版
.DESCRIPTION
    无条件强制重新编译 Debug 版后再重启 (Kill 并 Boot)
#>
[CmdletBinding()]
param(
    [switch]$CleanState,
    [switch]$NoBar
)

& "$PSScriptRoot\restart-dev-dist.ps1" -DebugBuild @PSBoundParameters