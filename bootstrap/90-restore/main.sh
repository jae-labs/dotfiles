#!/usr/bin/env bash

# Bootstrap Restore Script
# Restores files from Google Drive backup, preserving existing symlinks

set -euo pipefail

# List of required folders
REQUIRED_FOLDERS=(
  ".aws"
  ".oci"
  ".config"
  ".oh-my-zsh"
  ".ssh"
  "Desktop"
  "Documents"
  "mackup"
)

echo "Enter the path to your Google Drive backup folder (absolute path, e.g. /Volumes/GoogleDrive/My Drive/Backup):"
read -r BACKUP_PATH

# Check if backup path exists and is a directory
if [ ! -d "$BACKUP_PATH" ]; then
  echo "Error: Directory '$BACKUP_PATH' does not exist."
  exit 1
fi

# Check all required folders exist in backup
MISSING_FOLDERS=()
for folder in "${REQUIRED_FOLDERS[@]}"; do
  if [ ! -d "$BACKUP_PATH/$folder" ]; then
    MISSING_FOLDERS+=("$folder")
  fi
done

if [ ${#MISSING_FOLDERS[@]} -gt 0 ]; then
  echo "Error: The following required folders were not found in '$BACKUP_PATH':"
  for folder in "${MISSING_FOLDERS[@]}"; do
    echo "  - $folder"
  done
  exit 1
fi

echo "The following folders will be restored to your home directory:"
for folder in "${REQUIRED_FOLDERS[@]}"; do
  dest="$HOME/$folder"
  echo "  $folder -> $dest"
done
echo
printf "Proceed with restore? (y/N): "
read -r CONFIRM
case "$CONFIRM" in
  [Yy])
    # Proceed with restore
    ;;
  *)
    echo "Restore cancelled."
    exit 0
    ;;
esac

# Restore folders
for folder in "${REQUIRED_FOLDERS[@]}"; do
  src="$BACKUP_PATH/$folder"
  dest="$HOME/$folder"
  echo "Restoring $folder to $dest"
  # Create destination directory if it doesn't exist
  mkdir -p "$dest"

  # Copy files, skipping only symlinks in destination
  find "$src" -type f | while read -r file; do
    rel_path="${file#$src/}"
    dest_file="$dest/$rel_path"

    # Skip if destination file exists and is a symlink
    if [ -L "$dest_file" ]; then
      echo "Skipping symlink: $rel_path"
      continue
    fi

    # Create destination subdirectory if needed
    mkdir -p "$(dirname "$dest_file")"

    # Copy the file
    cp "$file" "$dest_file"
    echo "Copied: $rel_path"
  done
done

echo "Restore complete."
