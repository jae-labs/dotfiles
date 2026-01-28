#!/usr/bin/env bash

# Exit immediately if a command fails
set -e

# Ensure Homebrew is installed
if ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew not found. Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv 2>/dev/null || /usr/local/bin/brew shellenv 2>/dev/null)"
fi

SCRIPT_DIR="$(dirname "$0")"
DATA_DIR="data"
FORMULAE_FILE="$SCRIPT_DIR/$DATA_DIR/brew-formulae.txt"
CASKS_FILE="$SCRIPT_DIR/$DATA_DIR/brew-casks.txt"
TAPS_FILE="$SCRIPT_DIR/$DATA_DIR/brew-taps.txt"

print_help() {
  cat <<EOF
Usage: $(basename "$0") <command>

Commands:
  backup    Backup installed Homebrew formulae/casks/taps
  install   Install formulae/casks/taps from backup files
  upgrade   Update and upgrade Homebrew packages
  help      Show this help message
EOF
}

# Backup installed formulae, casks, and taps
backup_brew() {
  echo "Backing up installed Homebrew formulae to $FORMULAE_FILE..."
  brew list --formula --full-name >"$FORMULAE_FILE"
  echo "Backing up installed Homebrew casks to $CASKS_FILE..."
  brew list --cask --full-name >"$CASKS_FILE"
  echo "Backing up required Homebrew taps to $TAPS_FILE..."
  # Extract taps from full names (format: tap/name), filter valid taps (must be user/repo)
  TAPS=$(cat "$FORMULAE_FILE" "$CASKS_FILE" | grep -E '^[^/]+/[^/]+/' | sed 's|/.*||' | sort -u)
  # Also include currently tapped taps (for completeness), but only valid ones
  TAPS_ALL=$( (
    brew tap | grep -E '^[^/]+/[^/]+$' | sort -u
    echo "$TAPS"
  ) | grep -E '^[^/]+/[^/]+$' | sort -u)
  printf "%s\n" $TAPS_ALL >"$TAPS_FILE"
  echo "Backup complete."
}

# Install formulae, casks, and taps from backup files
install_brew() {
  if [[ ! -f "$FORMULAE_FILE" ]]; then
    echo "Formulae file not found: $FORMULAE_FILE" >&2
    exit 1
  fi
  if [[ ! -f "$CASKS_FILE" ]]; then
    echo "Casks file not found: $CASKS_FILE" >&2
    exit 1
  fi
  if [[ -f "$TAPS_FILE" ]]; then
    TAPS=()
    while IFS= read -r line; do
      TAPS+=("$line")
    done < <(grep -v '^#' "$TAPS_FILE" | grep -v '^$')
    if [[ ${#TAPS[@]} -gt 0 ]]; then
      echo "Tapping required Homebrew taps..."
      for tap in "${TAPS[@]}"; do
        brew tap "$tap" || true
      done
    fi
  fi
  FORMULAE=()
  while IFS= read -r line; do
    FORMULAE+=("$line")
  done < <(grep -v '^#' "$FORMULAE_FILE" | grep -v '^$')
  CASKS=()
  while IFS= read -r line; do
    CASKS+=("$line")
  done < <(grep -v '^#' "$CASKS_FILE" | grep -v '^$')
  echo "Installing formulae from $FORMULAE_FILE..."
  if [[ ${#FORMULAE[@]} -gt 0 ]]; then
    for formula in "${FORMULAE[@]}"; do
      echo "Installing $formula..."
      brew install "$formula"
    done
  else
    echo "No formulae to install."
  fi
  echo "Installing casks from $CASKS_FILE..."
  if [[ ${#CASKS[@]} -gt 0 ]]; then
    for cask in "${CASKS[@]}"; do
      echo "Installing $cask..."
      brew install --cask "$cask"
    done
  else
    echo "No casks to install."
  fi
  echo "All packages installed successfully!"
}

# Update and upgrade Homebrew
upgrade_brew() {
  echo "Updating Homebrew..."
  brew update
  echo "Upgrading Homebrew..."
  brew upgrade
}

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
help | --help | -h | "")
  print_help
  ;;
*)
  echo "Unknown command: $1" >&2
  print_help
  exit 1
  ;;
esac
