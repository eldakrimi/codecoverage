#!/usr/bin/env bash
# Enable strict mode
set -euo pipefail

# coverage.sh: Instruments and runs a Bash script to collect coverage traces.
# Usage: coverage.sh <script-path>

if [ $# -lt 1 ]; then
  echo "Usage: $0 <script-path>"
  exit 1
fi

SCRIPT_PATH="$1"

if [ ! -f "$SCRIPT_PATH" ]; then
  echo "Error: Script not found at '$SCRIPT_PATH'"
  exit 1
fi

# Prepare coverage log at project root (overwrite existing)
LOG="$(pwd)/coverage.log"
echo "SCRIPT_PATH=$SCRIPT_PATH" > "$LOG"

# Enable xtrace with file:line prefix and redirect traces to coverage.log
export PS4='+ ${BASH_SOURCE}:${LINENO}: '
bash -x "$SCRIPT_PATH" 2>>"$LOG" 