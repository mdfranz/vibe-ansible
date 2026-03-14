# vibe-ansible

Chromebook setup and management via Ansible, bootstrapped with UV for reproducible Python tooling.

I installed Claude first to generate this, then switched over to Gemini.

Tested on latest Debian ChromeBook and Ubuntu 24.04.4

## Overview

This project provides a bootstrap script for setting up a Chromebook Crostini (Debian/Ubuntu) environment with:
- **UV** — a fast Python package installer and project manager
- **Python** — pinned via UV (latest stable, ≥3.12)
- **Ansible** — for infrastructure automation and system configuration

All tooling is managed through UV, eliminating system-wide Python dependencies and ensuring reproducibility across machines.

## Quick Start

### Run the bootstrap script

```bash
bash bootstrap.sh
```

The script is idempotent — it's safe to run multiple times. It will:
- Install UV (if not already present)
- Install Python via UV
- Sync project dependencies and create a virtual environment

### Use the Control Script

The easiest way to manage components is using the `vibe.sh` script:

```bash
# Show help and available components
./vibe.sh

# Install all components
./vibe.sh install all

# Install a specific component
./vibe.sh install golang

# Uninstall a specific component
./vibe.sh uninstall neovim-astronvim

# Uninstall everything (in reverse order)
./vibe.sh uninstall all

# Forward ansible-playbook args through vibe.sh
./vibe.sh uninstall npm-packages --tags check,report
./vibe.sh install python-tools -e 'python_packages=["ruff"]'
```

### Run Ansible commands manually

If you prefer to run Ansible directly via UV:

```bash
# Test connectivity to localhost
uv run ansible localhost -m ping

# Run a specific playbook
uv run ansible-playbook ansible/install-golang.yml

# Use the unified package playbooks directly
uv run ansible-playbook ansible/python-tools.yml -e python_state=absent --tags apply
uv run ansible-playbook ansible/npm-packages.yml -e 'npm_packages=["@openai/codex"]'
```

## Project Structure

```
vibe-ansible/
├── bootstrap.sh          # Bootstrap script (install UV, Python, Ansible)
├── vibe.sh               # Main control script for install/uninstall
├── pyproject.toml        # UV project manifest (dependencies)
├── README.md             # This file
└── ansible/              # Ansible playbooks
    ├── install-cli-tools.yml         # Common tools (htop, tmux, ripgrep, etc.)
    ├── uninstall-cli-tools.yml       # Remove CLI tools
    ├── install-nodejs.yml            # Node.js (via nvm)
    ├── uninstall-nodejs.yml          # Remove Node.js and nvm
    ├── npm-packages.yml              # Unified npm package manager (present/absent)
    ├── install-npm-packages.yml      # Common global npm packages
    ├── uninstall-npm-packages.yml    # Remove global npm packages
    ├── python-tools.yml              # Unified Python tool manager (present/absent)
    ├── install-python-tools.yml      # Install Python CLI tools (wrapper)
    ├── uninstall-python-tools.yml    # Uninstall Python CLI tools (wrapper)
    ├── install-neovim-astronvim.yml   # Neovim binary and AstroNvim setup
    ├── uninstall-neovim-astronvim.yml # Remove Neovim and AstroNvim config
    ├── install-golang.yml            # Latest Go (Golang) binary setup
    └── uninstall-golang.yml          # Remove Go installation
```

## Available Components

- **cli-tools**: Standard utilities (htop, tmux, ripgrep, fzf, jq, tree, curl, wget, git, mosh, bottom)
- **nodejs**: Node.js LTS via nvm
- **npm-packages**: Global packages (@openai/codex, @google/gemini-cli)
- **python-tools**: Python CLI tools via uv (ruff, pre-commit, llm)
- **neovim-astronvim**: Neovim binary + AstroNvim configuration
- **golang**: Latest Go (Golang) installation

## Why UV?

- **Reproducible**: Locks Python version and all dependencies
- **Fast**: Optimized installer, much faster than pip
- **Self-contained**: No system-level Python version conflicts
- **Portable**: Works on any OS with bash and curl

## Requirements

- Debian/Ubuntu (tested on Crostini)
- `bash` and `curl`
- `sudo` access (for `apt-get` if curl needs installation)

## Troubleshooting

### UV not found after bootstrap

If `uv` is not in your PATH after running `bootstrap.sh`, add it manually:

```bash
export PATH="$HOME/.local/bin:$PATH"
```

Or add it permanently to your shell profile (`~/.bashrc` or `~/.zshrc`):

```bash
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

### Python not installed

Check available Python versions:

```bash
uv python list
```

To install a specific version:

```bash
uv python install 3.12
```

### Ansible import errors

Ensure you've run `uv sync`:

```bash
uv sync
```

Then verify Ansible is available:

```bash
uv run ansible --version
```

## Next Steps

- Add Ansible playbooks to the `ansible/` directory
- Create host inventory files (e.g., `hosts.ini`)
- Define roles for Chromebook setup tasks (development tools, environment config, etc.)

## License

MIT (or your preferred license)
