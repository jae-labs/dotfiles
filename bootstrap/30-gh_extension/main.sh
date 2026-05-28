#!/usr/bin/env bash

# Bootstrap GitHub CLI Extensions Setup
# Installs and manages GitHub CLI extensions

set -euo pipefail

SCRIPT_DIR="$(dirname "$0")"
DATA_DIR="data"
EXTENSIONS_FILE="$SCRIPT_DIR/$DATA_DIR/extensions.txt"

print_help() {
  cat <<EOF
Usage: $(basename "$0") <command>

Commands:
  install   Install GitHub CLI extensions
  upgrade   Upgrade all GitHub CLI extensions
  help      Show this help message
EOF
}

# Install GitHub CLI extensions
install_extensions() {
  if [ ! -f "$EXTENSIONS_FILE" ]; then
    echo "Extensions file not found: $EXTENSIONS_FILE" >&2
    exit 1
  fi
  echo "Installing GitHub CLI extensions from $EXTENSIONS_FILE..."
  while IFS= read -r extension; do
    if [ -n "$extension" ] && [[ ! "$extension" =~ ^# ]]; then
      echo "Installing $extension..."
      gh extension install "$extension"
    fi
  done < "$EXTENSIONS_FILE"
  echo "GitHub CLI extensions installed successfully!"
}

# Upgrade all GitHub CLI extensions
upgrade_extensions() {
  echo "Upgrading all GitHub CLI extensions..."
  gh extension upgrade --all
  echo "All GitHub CLI extensions upgraded successfully!"
}

# Check if command argument is provided
if [ $# -eq 0 ]; then
  print_help
  exit 0
fi

case "$1" in
install)
  install_extensions
  ;;
upgrade)
  upgrade_extensions
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
