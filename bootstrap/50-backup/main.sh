#!/usr/bin/env bash

# Bootstrap Backup Setup
# Manages macOS application backups and mackup configuration

set -euo pipefail

SCRIPT_DIR="$(dirname "$0")"
DATA_DIR="data"
APPS_FILE="$SCRIPT_DIR/$DATA_DIR/macos-apps.yaml"

print_help() {
  cat <<EOF
Usage: $(basename "$0") <command>

Commands:
  backup    Backup list of /Applications into macos-apps.yaml and run mackup
  help      Show this help message
EOF
}

backup() {
  echo "apps:" >"$APPS_FILE"
  find /Applications -maxdepth 2 -name "*.app" -prune | while read appPath; do
    appName=$(basename "$appPath" .app)
    copyright=$(mdls -name kMDItemCopyright -raw "$appPath")
    [ "$copyright" == "(null)" ] && copyright="Unknown"
    echo "  - name: \"$appName\"" >>"$APPS_FILE"
    echo "    copyright: \"$copyright\"" >>"$APPS_FILE"
  done
  echo "Backed up app list to $APPS_FILE"
  echo "Running mackup to backup app settings..."
  mackup backup --force
}

# Check if command argument is provided
if [ $# -eq 0 ]; then
  print_help
  exit 0
fi

case "$1" in
backup)
  backup
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
