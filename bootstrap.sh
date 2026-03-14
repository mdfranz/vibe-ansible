#!/bin/bash
set -euo pipefail

# Bootstrap script for vibe-ansible
# Installs UV, Python, and sets up Ansible via uv sync

echo "=== vibe-ansible bootstrap ==="

# Step 1: Ensure curl is available
if ! command -v curl &> /dev/null; then
    echo "curl not found, installing..."
    sudo apt-get update
    sudo apt-get install -y curl
fi

# Step 2: Install UV (idempotent check)
if command -v uv &> /dev/null; then
    echo "UV already installed: $(uv --version)"
else
    echo "Installing UV..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
    # Add UV to PATH for current session
    export PATH="$HOME/.local/bin:$PATH"
fi

# Step 3: Verify UV is in PATH
if ! command -v uv &> /dev/null; then
    export PATH="$HOME/.local/bin:$PATH"
fi

# Step 4: Install latest stable Python via UV
echo "Installing Python via UV..."
uv python install

# Step 5: Sync project dependencies (creates venv, installs ansible, etc.)
echo "Syncing project dependencies..."
uv sync

echo ""
echo "=== Bootstrap complete ==="
echo ""
echo "Usage:"
echo "  Run Ansible playbooks with: uv run ansible-playbook <playbook.yml>"
echo "  Run ad-hoc Ansible commands with: uv run ansible <host> -m <module>"
echo "  Test connectivity: uv run ansible localhost -m ping"
