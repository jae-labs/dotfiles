#!/bin/bash
# Prints MIC_IN_USE / MIC_NOT_IN_USE. Auto-(re)compiles the Swift helper
# on first use or whenever meeting-detect.swift is newer than the binary,
# so nothing needs to be built manually after a fresh dotfiles checkout.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BIN="$DIR/meeting-detect"
SRC="$DIR/meeting-detect.swift"

if [ ! -x "$BIN" ] || [ "$SRC" -nt "$BIN" ]; then
  swiftc -O -o "$BIN" "$SRC" -framework CoreAudio 2>/dev/null
fi

"$BIN" 2>/dev/null || echo MIC_NOT_IN_USE
