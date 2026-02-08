#!/usr/bin/env bash
# setup-workspace.sh — initialize agent workspace after first login
set -euo pipefail

echo "=== Agent Workspace Setup ==="

# Create standard directories
mkdir -p ~/projects ~/scratch

# Check SSH key
if [[ ! -f ~/.ssh/id_ed25519 ]]; then
    echo ""
    echo "No SSH key found. Generate one with:"
    echo "  ssh-keygen -t ed25519 -C 'agent@$(hostname)' -N '' -f ~/.ssh/id_ed25519"
fi

# Check GitHub auth
if ! gh auth status &>/dev/null; then
    echo ""
    echo "GitHub CLI not authenticated. Set up with:"
    echo "  gh auth login"
    echo "  OR copy token: gh auth login --with-token < /path/to/token"
fi

# Check git identity
if ! git config user.name &>/dev/null; then
    echo ""
    echo "Git identity not set. Configure with:"
    echo "  git config --global user.name 'Agent Name'"
    echo "  git config --global user.email 'agent@example.com'"
fi

echo ""
echo "Workspace ready. Projects go in ~/projects/"
