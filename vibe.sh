#!/bin/bash
set -euo pipefail

# vibe.sh - Control script for vibe-ansible components
# Usage: ./vibe.sh [install|uninstall] [component|all]

COMPONENTS=("nodejs" "golang" "cli-tools" "npm-packages" "python-tools" "neovim-astronvim")

show_help() {
    echo "Usage: $0 [action] [component]"
    echo ""
    echo "Actions:"
    echo "  install      Install the specified component(s)"
    echo "  uninstall    Uninstall the specified component(s)"
    echo ""
    echo "Components:"
    for comp in "${COMPONENTS[@]}"; do
        echo "  $comp"
    done
    echo "  all          Run action for ALL components"
    echo ""
    echo "Example:"
    echo "  $0 install golang"
    echo "  $0 uninstall all"
}

if [ $# -lt 2 ]; then
    show_help
    exit 1
fi

ACTION=$1
TARGET=$2

# Validate action
if [[ ! "$ACTION" =~ ^(install|uninstall)$ ]]; then
    echo "Error: Invalid action '$ACTION'. Use 'install' or 'uninstall'."
    exit 1
fi

run_playbook() {
    local act=$1
    local comp=$2
    local playbook="ansible/${act}-${comp}.yml"
    
    if [ -f "$playbook" ]; then
        echo "===> Running ${act} for ${comp}..."
        uv run ansible-playbook "$playbook"
    else
        echo "Warning: Playbook $playbook not found, skipping."
    fi
}

if [ "$TARGET" == "all" ]; then
    if [ "$ACTION" == "install" ]; then
        # Install order matters for dependencies (e.g., nodejs before npm-packages)
        for comp in "${COMPONENTS[@]}"; do
            run_playbook "install" "$comp"
        done
    else
        # Uninstall in reverse order
        for ((i=${#COMPONENTS[@]}-1; i>=0; i--)); do
            run_playbook "uninstall" "${COMPONENTS[$i]}"
        done
    fi
else
    # Validate component
    FOUND=false
    for comp in "${COMPONENTS[@]}"; do
        if [ "$comp" == "$TARGET" ]; then
            FOUND=true
            break
        fi
    done

    if [ "$FOUND" = true ]; then
        run_playbook "$ACTION" "$TARGET"
    else
        echo "Error: Unknown component '$TARGET'."
        show_help
        exit 1
    fi
fi

echo "===> $ACTION $TARGET complete!"
