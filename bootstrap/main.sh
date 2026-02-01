#!/usr/bin/env bash

# Dotfiles Bootstrap Main Script
# Orchestrates the complete dotfiles setup process

set -euo pipefail

SCRIPT_DIR="$(dirname "$0")"

echo "Starting dotfiles bootstrap..."

# Run brew setup
echo "Setting up Homebrew..."
"$SCRIPT_DIR/10-brew/main.sh" install

# Run mise setup
echo "Setting up Mise..."
"$SCRIPT_DIR/20-mise/main.sh"

# Run GitHub CLI setup
echo "Setting up GitHub CLI extensions..."
"$SCRIPT_DIR/30-gh_extension/main.sh"

# Run symlink setup
echo "Setting up symlinks..."
"$SCRIPT_DIR/40-symlink/main.sh"

echo "Bootstrap completed successfully!"
