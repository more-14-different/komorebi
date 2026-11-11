<#
.SYNOPSIS
    重启 (Kill 并 Boot) komorebi dev release 版 (缺失时自动 build，不缺失时纯启动/纯重启)
#>
[CmdletBinding()]
param(
    [switch]$CleanState,
    [switch]$NoBar,
    [switch]$Rebuild
)

& "$PSScriptRoot\restart-dev-dist.ps1" @PSBoundParameters