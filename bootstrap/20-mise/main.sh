#!/usr/bin/env bash

# Bootstrap Mise Setup
# Installs tools and environments defined in mise configuration

set -euo pipefail

# Ensure mise is installed
if ! command -v mise >/dev/null 2>&1; then
  echo "Mise not found. Installing Mise..."
  curl https://mise.run | sh
  eval "$($HOME/.local/bin/mise activate bash)"
fi

print_help() {
  cat <<EOF
Usage: $(basename "$0") <command>

Commands:
  install   Install tools and environments from global mise configuration
  upgrade   Upgrade tools and environments from global mise configuration
  cleanup   Clean up old mise versions and cache
  help      Show this help message
EOF
}

# Install tools and environments from mise configuration
install_mise() {
  echo "Installing tools and environments from mise configuration..."
  mise install
  echo "All mise tools installed successfully!"
}

# Upgrade tools and environments from mise configuration
upgrade_mise() {
  echo "Upgrading tools and environments from mise configuration..."
  mise upgrade --bump
  echo "All mise tools upgraded successfully!"
}

# Clean up old mise versions and cache
cleanup_mise() {
  echo "Cleaning up mise..."
  mise prune -y
  echo "Mise cleanup complete."
}

# Check if command argument is provided
if [ $# -eq 0 ]; then
  print_help
  exit 0
fi

case "$1" in
install)
  install_mise
  ;;
upgrade)
  upgrade_mise
  ;;
cleanup)
  cleanup_mise
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
