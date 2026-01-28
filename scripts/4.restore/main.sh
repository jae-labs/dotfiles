#!/bin/bash

# Exit immediately if a command fails
set -e

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
if [[ ! -d "$BACKUP_PATH" ]]; then
  echo "Error: Directory '$BACKUP_PATH' does not exist."
  exit 1
fi

# Check all required folders exist in backup
MISSING_FOLDERS=()
for folder in "${REQUIRED_FOLDERS[@]}"; do
  if [[ ! -d "$BACKUP_PATH/$folder" ]]; then
    MISSING_FOLDERS+=("$folder")
  fi
done

if [[ ${#MISSING_FOLDERS[@]} -gt 0 ]]; then
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
if [[ ! "$CONFIRM" =~ ^[Yy]$ ]]; then
  echo "Restore cancelled."
  exit 0
fi

# Restore folders
for folder in "${REQUIRED_FOLDERS[@]}"; do
  src="$BACKUP_PATH/$folder"
  dest="$HOME/$folder"
  echo "Restoring $folder to $dest"
  cp -R "$src" "$dest"
done

echo "Restore complete."
