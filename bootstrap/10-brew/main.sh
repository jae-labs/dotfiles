#!/usr/bin/env bash

# Bootstrap Homebrew Setup
# Manages Homebrew installation, package backup, and restoration

set -euo pipefail

# Ensure Homebrew is installed
if ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew not found. Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv 2>/dev/null || /usr/local/bin/brew shellenv 2>/dev/null)"
fi

SCRIPT_DIR="$(dirname "$0")"
DATA_DIR="data"
BREWFILE="$SCRIPT_DIR/$DATA_DIR/Brewfile"

print_help() {
  cat <<EOF
Usage: $(basename "$0") <command>

Commands:
  backup    Backup installed Homebrew formulae/casks/taps
  install   Install formulae/casks/taps from Brewfile
  upgrade   Update and upgrade Homebrew packages
  cleanup   Clean up Homebrew cache and old versions
  help      Show this help message
EOF
}

# Backup installed formulae, casks, and taps to Brewfile
backup_brew() {
  echo "Backing up installed Homebrew packages to $BREWFILE..."
  brew bundle dump --file="$BREWFILE" --force --describe
  echo "Backup complete."
}

# Install formulae, casks, and taps from Brewfile
install_brew() {
  if [ ! -f "$BREWFILE" ]; then
    echo "Brewfile not found: $BREWFILE" >&2
    exit 1
  fi
  echo "Installing packages from $BREWFILE..."
  brew bundle install --file="$BREWFILE" --no-upgrade
  echo "All packages installed successfully!"
}

# Update and upgrade Homebrew
upgrade_brew() {
  echo "Updating Homebrew based on Brewfile..."
  brew bundle upgrade --file="$BREWFILE"
  echo "Upgrading Homebrew..."
  brew upgrade
}

# Clean up Homebrew cache and old versions
cleanup_brew() {
  echo "Cleaning up Homebrew..."
  brew cleanup
  echo "Homebrew cleanup complete."
}

# Check if command argument is provided
if [ $# -eq 0 ]; then
  print_help
  exit 0
fi

case "$1" in
backup)
  backup_brew
  ;;
install)
  install_brew
  ;;
upgrade)
  upgrade_brew
  ;;
cleanup)
  cleanup_brew
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
