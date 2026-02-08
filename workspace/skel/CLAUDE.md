# Agent Environment

You are running inside an isolated NixOS container managed by rsi-toolset.

## Available Tools
- **git**, **gh** — version control and GitHub CLI
- **claude** — Claude Code CLI
- **python3**, **node** — scripting runtimes
- **gcc**, **make** — compilation
- **ripgrep**, **fd**, **jq**, **yq** — search and data processing
- **curl**, **wget** — HTTP clients
- **tmux** — terminal multiplexing
- **nix** — Nix package manager (flakes enabled)

## Environment
- User: `agent` with passwordless sudo
- Home: `/home/agent`
- Projects: `~/projects/`
- Internet access: outbound only (no inbound services)

## Conventions
- Work in `~/projects/`
- Use git for all code changes
- Install additional tools with `nix-env -iA nixos.<package>` or add to the container config
