#!/usr/bin/env bash

# Dotfiles Bootstrap Main Script
# Orchestrates the complete dotfiles setup process

set -euo pipefail

SCRIPT_DIR="$(dirname "$0")"

print_help() {
  cat <<EOF
Usage: $(basename "$0") <command>

Commands:
  install       Run full dotfiles installation
  force-install Run full dotfiles installation with force mode
  upgrade       Run full dotfiles upgrade
  cleanup       Clean up brew and mise caches/old versions
  help          Show this help message
EOF
}

install_dotfiles() {
  echo "Starting dotfiles bootstrap installation..."

  # Run brew setup
  echo "Setting up Homebrew..."
  "$SCRIPT_DIR/10-brew/main.sh" install

  # Run mise setup
  echo "Setting up Mise..."
  "$SCRIPT_DIR/20-mise/main.sh" install

  # Run GitHub CLI setup
  echo "Setting up GitHub CLI extensions..."
  "$SCRIPT_DIR/30-gh_extension/main.sh" install

  # Run symlink setup
  echo "Setting up symlinks..."
  "$SCRIPT_DIR/40-symlink/main.sh" install

  # Run backup setup
  echo "Setting up backups..."
  "$SCRIPT_DIR/50-backup/main.sh" backup

  echo "Bootstrap installation completed successfully!"
}

force_install_dotfiles() {
  echo "Starting dotfiles bootstrap force installation..."

  # Run brew setup
  echo "Setting up Homebrew..."
  "$SCRIPT_DIR/10-brew/main.sh" install

  # Run mise setup
  echo "Setting up Mise..."
  "$SCRIPT_DIR/20-mise/main.sh" install

  # Run GitHub CLI setup
  echo "Setting up GitHub CLI extensions..."
  "$SCRIPT_DIR/30-gh_extension/main.sh" install

  # Run symlink setup with force mode
  echo "Setting up symlinks with force mode..."
  "$SCRIPT_DIR/40-symlink/main.sh" force-install

  # Run backup setup
  echo "Setting up backups..."
  "$SCRIPT_DIR/50-backup/main.sh" backup

  echo "Bootstrap force installation completed successfully!"
}

upgrade_dotfiles() {
  echo "Starting dotfiles bootstrap upgrade..."

  # Run brew upgrade
  echo "Upgrading Homebrew..."
  "$SCRIPT_DIR/10-brew/main.sh" upgrade

  # Run mise upgrade
  echo "Upgrading Mise..."
  "$SCRIPT_DIR/20-mise/main.sh" upgrade

  # Run GitHub CLI upgrade
  echo "Upgrading GitHub CLI extensions..."
  "$SCRIPT_DIR/30-gh_extension/main.sh" upgrade

  # Run symlink setup (to ensure links are current)
  echo "Updating symlinks..."
  "$SCRIPT_DIR/40-symlink/main.sh" install

  echo "Bootstrap upgrade completed successfully!"
}

cleanup_dotfiles() {
  echo "Starting dotfiles bootstrap cleanup..."

  # Run brew cleanup
  echo "Cleaning up Homebrew..."
  "$SCRIPT_DIR/10-brew/main.sh" cleanup

  # Run mise cleanup
  echo "Cleaning up Mise..."
  "$SCRIPT_DIR/20-mise/main.sh" cleanup

  echo "Bootstrap cleanup completed successfully!"
}

# Check if command argument is provided
if [ $# -eq 0 ]; then
  print_help
  exit 0
fi

case "$1" in
install)
  install_dotfiles
  ;;
force-install)
  force_install_dotfiles
  ;;
upgrade)
  upgrade_dotfiles
  ;;
cleanup)
  cleanup_dotfiles
  ;;
help | --help | -h)
  print_help
  ;;
*)
  echo "Unknown command: $1" >&2
  print_help
  exit 1
  ;;
esac
