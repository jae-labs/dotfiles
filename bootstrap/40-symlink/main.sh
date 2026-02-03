#!/usr/bin/env bash

# Bootstrap Symlink Setup
# Creates symbolic links from home directory to dotfiles repository

set -euo pipefail

FORCE_MODE=false
DRY_RUN=false
DOTFILES_DIR="$(cd "$(dirname "$0")/../.." && pwd)" # Base directory where dotfiles are stored

print_help() {
  cat <<EOF
Usage: $0 [command]

Options:
  install   Run the symlink installation process.
  force-install   Remove and replace existing files/symlinks.
  dry-run   Show what would be done, but make no changes.
  help      Show this help message.
EOF
}

# Define symlinks as relative paths from dotfiles root
# Each path will be linked from: $HOME/<path> -> $DOTFILES_DIR/<path>
SYMLINK_DEFINITIONS=(
  ".zsh_kraft_completion"
  ".config/eza/theme.yml"
  ".config/gh"
  ".config/mise/config.toml"
  ".config/nvim"
  ".config/starship.toml"
  ".config/yazi"
  ".config/ccstatusline"
  ".curlrc"
  ".editorconfig"
  ".gitconfig"
  ".gitignore"
  ".gitleaks.toml"
  ".gitmessage"
  ".hushlogin"
  ".inputrc"
  ".lefthook.yml"
  ".mackup.cfg"
  ".rspec"
  ".screenrc"
  ".ssh/config"
  ".tmux.conf"
  ".tmux.conf.local"
  ".wgetrc"
  ".zshrc"
  "ansible.cfg"
  "dialogrc"
  ".aliases.d"
  "Library/Application Support/Code/User/settings.json"
  "Library/Application Support/Windsurf/User/settings.json"
  ".claude/CLAUDE.md"
  ".codeium/windsurf/memories/global_rules.md"
  ".gemini/GEMINI.md"
  ".codeium/windsurf/mcp_config.json"
  ".claude/settings.json"
)

print_symlink_info() {
  local abs_source_path="$1"
  local abs_target_path="$2"
  echo -e "\nProcessing symlink:"
  echo "Source: $abs_source_path"
  echo "Target: $abs_target_path"
}

# Ensure parent directory exists
ensure_parent_dir() {
  local abs_target_path="$1"
  local parent_dir
  parent_dir="$(dirname "$abs_target_path")"
  if [ ! -d "$parent_dir" ]; then
    if [ "$DRY_RUN" = false ]; then
      mkdir -p "$parent_dir"
      echo "Created parent directory: $parent_dir"
    else
      echo "[DRY RUN] Would create parent directory: $parent_dir"
    fi
  fi
}

# Check if target exists and if it's a correct symlink
check_target_exists() {
  local abs_target_path="$1"
  local abs_source_path="$2"
  local current_link=""
  local exists=0
  if [ -L "$abs_target_path" ]; then
    current_link="$(readlink "$abs_target_path")"
    exists=1
  elif [ -e "$abs_target_path" ]; then
    exists=1
  fi
  echo "$exists|$current_link"
}

# Handle existing target (not the correct symlink)
handle_existing_target() {
  local abs_target_path="$1"
  local abs_source_path="$2"
  local current_link="$3"
  if [ "$FORCE_MODE" = true ]; then
    mv "$abs_target_path" "$abs_target_path.bak.$(date +%s)"
    echo "[FORCE] Moved existing $abs_target_path to $abs_target_path.bak.$(date +%s)"
    ln -sf "$abs_source_path" "$abs_target_path"
    echo "Linked $abs_target_path -> $abs_source_path"
  elif [ "$DRY_RUN" = true ]; then
    if [ -n "$current_link" ]; then
      echo "[DRY RUN] CUR $abs_target_path > $current_link"
    fi
    echo "[DRY RUN] BAK $abs_target_path -> $abs_target_path.bak.$(date +%s)"
    echo "[DRY RUN] NEW $abs_target_path -> $abs_source_path"
  else
    echo "Error: $abs_target_path exists and is not the correct symlink. Use 'force' to override or remove it." >&2
    exit 1
  fi
}

# Link target (when it does not exist)
link_target() {
  local abs_target_path="$1"
  local abs_source_path="$2"
  if [ "$DRY_RUN" = true ]; then
    echo "[DRY RUN] NEW $abs_target_path -> $abs_source_path"
  else
    ln -sf "$abs_source_path" "$abs_target_path"
    echo "Linked $abs_target_path -> $abs_source_path"
  fi
}

# Main orchestrator for symlink creation
create_symlink() {
  local rel_path="$1"
  local abs_target_path="$HOME/$rel_path"
  local abs_source_path="$DOTFILES_DIR/$rel_path"

  print_symlink_info "$abs_source_path" "$abs_target_path"
  ensure_parent_dir "$abs_target_path"

  local exists_and_link
  exists_and_link=$(check_target_exists "$abs_target_path" "$abs_source_path")
  local exists current_link
  exists="${exists_and_link%%|*}"
  current_link="${exists_and_link#*|}"

  if [ "$exists" -eq 1 ]; then
    if [ -L "$abs_target_path" ] && [ "$current_link" = "$abs_source_path" ]; then
      echo "$abs_target_path already correctly points to $abs_source_path, nothing to do."
      return
    fi
    handle_existing_target "$abs_target_path" "$abs_source_path" "$current_link"
  else
    link_target "$abs_target_path" "$abs_source_path"
  fi
}

# Main function
main() {
  # Main loop
  for definition in "${SYMLINK_DEFINITIONS[@]}"; do
    create_symlink "$definition"
  done
}

# Check if command argument is provided
if [ $# -eq 0 ]; then
  print_help
  exit 0
fi

case "$1" in
install)
  main
  ;;
force-install)
  FORCE_MODE=true
  main
  ;;
dry-run)
  DRY_RUN=true
  main
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
