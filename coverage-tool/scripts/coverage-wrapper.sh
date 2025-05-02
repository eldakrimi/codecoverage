#!/usr/bin/env bash
set -euo pipefail

# coverage-wrapper.sh: Orchestrate Bash coverage for a BATS test.
# Usage: coverage-wrapper.sh <path-to-bats-test>

if [ $# -lt 1 ]; then
  echo "Usage: $0 <path-to-bats-test>"
  exit 1
fi

BATS_PATH="$1"
if [ ! -f "$BATS_PATH" ]; then
  echo "Error: BATS test not found at '$BATS_PATH'"
  exit 1
fi

# Ensure .bats extension
if [[ "${BATS_PATH##*.}" != "bats" ]]; then
  echo "Error: File must be a .bats test file"
  exit 1
fi

# Get absolute paths
BATS_DIR="$(cd "$(dirname "$BATS_PATH")" && pwd)"
PROJECT_ROOT="$(cd "$(dirname "$BATS_PATH")/.." && pwd)"

# Extract CWD and CMD variables
CWD_VAL=$(grep -E '^CWD=' "$BATS_PATH" | head -n1 | cut -d'=' -f2- | tr -d '"' | tr -d "'")
CMD_VAL=$(grep -E '^CMD=' "$BATS_PATH" | head -n1 | cut -d'=' -f2- | tr -d '"' | tr -d "'")
if [ -z "$CWD_VAL" ] || [ -z "$CMD_VAL" ]; then
  echo "Error: BATS test must define CWD and CMD variables"
  exit 1
fi

# Resolve script path relative to project root
SCRIPT_PATH="$PROJECT_ROOT/$CWD_VAL/$CMD_VAL"
if [ ! -f "$SCRIPT_PATH" ]; then
  echo "Error: Script not found at '$SCRIPT_PATH'"
  exit 1
fi

echo "Running coverage for: $SCRIPT_PATH"

# Setup output directories
ROOT_DIR="$(pwd)"
LOG_PATH="$ROOT_DIR/coverage.log"
REPORTS_DIR="$ROOT_DIR/coverage-reports"
mkdir -p "$REPORTS_DIR"

# Instrument and run the script
bash "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/coverage.sh" "$SCRIPT_PATH"

# Execute the BATS test (so coverage.log gets real traces)
bats "$BATS_PATH"

# Generate JSON report
ts-node "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../src/main.ts" \
  "$LOG_PATH" \
  "$REPORTS_DIR/coverage.json" 