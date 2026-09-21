# Local Rules for `komorebi-fork`

## Overview

- This repository (`E:\MCP\Projects\komorebi`) is the local fork of Komorebi with hang-immunity and non-blocking timeout patches.
- Its development configuration is maintained in `D:\C2D\dotfiles\komorebi-dev`.
- Do NOT overwrite the official Scoop installation in `E:\Scoop\apps\komorebi\current\`. Dev builds and runs should target `target\release` (or `target\debug`).

## Configuration & Dotfiles

- Config home: `D:\C2D\dotfiles\komorebi-dev`
- Marker: `D:\C2D\dotfiles\komorebi-dev\.komorebi-config-role` containing `komorebi-fork`.
- Validated via `assert-dev-config.ps1`.

## Scripts in this Repository

- `build-dev.ps1`: Builds `komorebi` and `komorebic` using `cargo build --release` (or with `-Debug`).
- `restart-dev-dist.ps1`: Asserts dev config, builds, and reboots Komorebi Dev via `komorebi-dev\run-komorebi-dumped-session.ps1`.
- `rebuild-and-reboot.ps1`: Convenience alias for `restart-dev-dist.ps1`.
- `start-dev-dist.ps1`: Starts the built dev `komorebi.exe` pointing to `komorebi-dev\komorebi.json`.
- `run-dev.ps1`: Runs `komorebi.exe` directly in the current console for debugging.
