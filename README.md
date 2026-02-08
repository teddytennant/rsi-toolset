# rsi-toolset

A framework for running autonomous AI agent containers on NixOS. Each agent runs in an isolated NixOS container with its own tooling, networking, and home directory.

## Quick Start

```bash
# 1. Add host config (see host/container-host.nix)
# 2. Create an agent
rsi create myagent

# 3. Shell in
rsi shell myagent
```

## CLI

All commands go through `bin/rsi <command>`. Agent names must be lowercase alphanumeric, max 7 characters.

### Agent Lifecycle

| Command | Description |
|---|---|
| `rsi create <name> [profile]` | Create a new agent container (default profile if omitted) |
| `rsi destroy <name>` | Destroy an agent container |
| `rsi start <name>` | Start a stopped container |
| `rsi stop <name>` | Stop a running container |
| `rsi list` | List all agent containers |

### Access

| Command | Description |
|---|---|
| `rsi shell <name>` | Shell into container as the agent user |
| `rsi root <name>` | Root shell into container |
| `rsi run <name> <cmd...>` | Run a command inside the container |

### Setup

| Command | Description |
|---|---|
| `rsi ssh-setup <name>` | Generate SSH keys for the agent |
| `rsi gh-auth <name>` | Set up GitHub authentication |

### Maintenance

| Command | Description |
|---|---|
| `rsi snapshot <name>` | Snapshot the agent's home directory |
| `rsi restore <name> [snap]` | Restore from a snapshot |
| `rsi update <name>` | Rebuild container with latest config |

## Project Structure

```
bin/            CLI tools (bash scripts)
lib/            Shared bash library
modules/        Composable NixOS modules
  base.nix        Core agent user, sudo, locale, nix-ld
  networking.nix  Container networking
  security.nix    Security hardening
  dev-tools.nix   Development tools (git, etc.)
  ai-tools.nix    AI tools (claude-code, nodejs, python)
  build-tools.nix Build toolchains
  nix-tools.nix   Nix development tools
profiles/       Pre-composed module sets
  default.nix     All modules
  minimal.nix     Base + networking + dev-tools only
host/           Host NixOS config snippets
workspace/skel/ Template for agent home directories
```

## Profiles

- **default** — Includes all modules: base, networking, security, dev-tools, ai-tools, build-tools, nix-tools.
- **minimal** — Lighter setup with just base, networking, and dev-tools.

Create an agent with a specific profile:

```bash
rsi create myagent minimal
```

## Host Requirements

- NixOS with `boot.enableContainers = true`
- NAT configuration for container networking (see `host/container-host.nix`)
- Adjust `externalInterface` in the NAT config to match your host's network interface

## How It Works

Agents run as NixOS containers managed by `nixos-container`. Each container gets:

- An `agent` user with passwordless sudo
- Nix flakes enabled
- `nix-ld` for running dynamically linked executables
- Networking via veth pairs with NAT to the host
- A home directory seeded from `workspace/skel/`

Container names are prefixed with `rsi-` (e.g., agent "t1" becomes container "rsi-t1"). The 7-character name limit exists because Linux veth interface names max out at 11 characters.
