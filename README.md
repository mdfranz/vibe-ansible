# vibe-ansible

Chromebook setup and management via Ansible, bootstrapped with UV for reproducible Python tooling.

I installed Claude first to generate this, then switched over to Gemini.

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

### Run Ansible commands

Once bootstrap completes, use UV to run Ansible:

```bash
# Test connectivity to localhost
uv run ansible localhost -m ping

# Run a playbook
uv run ansible-playbook playbooks/setup.yml

# Run ad-hoc commands
uv run ansible <host> -m shell -a "uptime"
```

## Project Structure

```
vibe-ansible/
├── bootstrap.sh          # Bootstrap script (install UV, Python, Ansible)
├── pyproject.toml        # UV project manifest (dependencies)
├── README.md             # This file
└── ansible/              # Ansible playbooks
    ├── install-cli-tools.yml       # Common tools (htop, tmux, ripgrep, etc.)
    ├── install-nodejs.yml          # Node.js (via home directory extraction)
    ├── install-npm-packages.yml    # Common global npm packages
    ├── install-neovim-astronvim.yml # Neovim binary and AstroNvim setup
    ├── install-golang.yml          # Latest Go (Golang) binary setup
    └── uninstall-nodejs.yml        # Clean up Node.js installation
```

## Available Playbooks

Run these playbooks using `uv run ansible-playbook`:

- **CLI Tools**: `uv run ansible-playbook ansible/install-cli-tools.yml`
- **Node.js**: `uv run ansible-playbook ansible/install-nodejs.yml`
- **Neovim & AstroNvim**: `uv run ansible-playbook ansible/install-neovim-astronvim.yml`
- **Go (Golang)**: `uv run ansible-playbook ansible/install-golang.yml`

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
