# vibe-ansible

Chromebook setup and management via Ansible, bootstrapped with UV for reproducible Python tooling.

## Overview

This project provides a bootstrap script for setting up a Chromebook Crostini (Debian/Ubuntu) environment with:
- **UV** — a fast Python package installer and project manager
- **Python** — pinned via UV (latest stable, ≥3.12)
- **Ansible** — for infrastructure automation and system configuration

All tooling is managed through UV, eliminating system-wide Python dependencies and ensuring reproducibility across machines.

## Quick Start

### 1. Clone the repository

```bash
git clone https://github.com/yourusername/vibe-ansible.git
cd vibe-ansible
```

### 2. Run the bootstrap script

```bash
bash bootstrap.sh
```

The script is idempotent — it's safe to run multiple times. It will:
- Install UV (if not already present)
- Install Python via UV
- Sync project dependencies and create a virtual environment

### 3. Run Ansible commands

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
└── ansible/              # Ansible playbooks and roles (future)
    └── .gitkeep
```

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
