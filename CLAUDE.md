# rsi-toolset

Framework for running autonomous RSI (recursive self-improvement) AI agent containers on NixOS.

## Structure

- `modules/` — Composable NixOS modules defining agent capabilities
- `profiles/` — Pre-composed module sets (default, minimal)
- `workspace/skel/` — Agent home directory template
- `host/` — Host NixOS config snippets
- `bin/` — CLI tools (all bash)
- `lib/` — Shared bash library

## CLI

All commands: `bin/rsi <command>`. Agent names max 7 chars, lowercase alphanumeric.

## NixOS Modules

Plain NixOS configuration.nix style (no flakes, no home-manager). Modules are imported by profiles which are passed to `nixos-container create --config-file`.

## Development

- Shell scripts only, no compiled languages
- Test with: `rsi create t1 && rsi shell t1`
- Container names are prefixed `rsi-` (e.g., agent "t1" = container "rsi-t1")
- Linux veth limit: container names max 11 chars total

## Host Requirements

- NixOS with `boot.enableContainers = true`
- NAT config for container networking (see `host/container-host.nix`)
