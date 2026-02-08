#!/usr/bin/env bash
# Shared library for rsi-toolset CLI scripts

set -euo pipefail

RSI_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
RSI_PREFIX="rsi-"
# Find nixos-container — may not be on PATH depending on host config
if command -v nixos-container &>/dev/null; then
    NIXOS_CONTAINER="nixos-container"
else
    NIXOS_CONTAINER="$(find /nix/store -maxdepth 3 -name nixos-container -type f 2>/dev/null | head -1)"
    if [[ -z "$NIXOS_CONTAINER" ]]; then
        echo "Error: nixos-container not found" >&2
        exit 1
    fi
fi
DEFAULT_PROFILE="${RSI_ROOT}/profiles/default.nix"

# Container name max 11 chars (Linux veth interface limit)
# Prefix is 4 chars ("rsi-"), so agent name max 7 chars
MAX_NAME_LEN=7

container_name() {
    echo "${RSI_PREFIX}${1}"
}

validate_name() {
    local name="$1"
    if [[ ${#name} -gt $MAX_NAME_LEN ]]; then
        echo "Error: agent name '${name}' too long (max ${MAX_NAME_LEN} chars, got ${#name})" >&2
        return 1
    fi
    if [[ ! "$name" =~ ^[a-z][a-z0-9]*$ ]]; then
        echo "Error: agent name must start with a letter and contain only lowercase letters/numbers" >&2
        return 1
    fi
}

container_exists() {
    local cn
    cn="$(container_name "$1")"
    sudo "$NIXOS_CONTAINER" list 2>/dev/null | grep -qw "$cn"
}

container_running() {
    local cn
    cn="$(container_name "$1")"
    sudo "$NIXOS_CONTAINER" status "$cn" 2>/dev/null | grep -q "Up"
}

require_container() {
    local name="$1"
    if ! container_exists "$name"; then
        echo "Error: agent '${name}' does not exist" >&2
        echo "Run 'rsi list' to see available agents" >&2
        return 1
    fi
}

require_running() {
    local name="$1"
    require_container "$name"
    if ! container_running "$name"; then
        echo "Error: agent '${name}' is not running" >&2
        echo "Run 'rsi start ${name}' first" >&2
        return 1
    fi
}

require_not_exists() {
    local name="$1"
    if container_exists "$name"; then
        echo "Error: agent '${name}' already exists" >&2
        return 1
    fi
}
