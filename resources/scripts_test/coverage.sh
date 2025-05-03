#!/usr/bin/env bash
# Enable strict mode
set -euo pipefail

# coverage.sh: Functions for collecting coverage of Bash scripts in BATS tests.
# Usage: load coverage.sh

# Function to collect coverage for a script
collect_coverage() {
    local script_path="$1"
    local log_path="$2"
    
    # Prepare coverage log (overwrite existing)
    echo "SCRIPT_PATH=$script_path" > "$log_path"
    
    # Enable xtrace with file:line prefix and redirect traces to coverage.log
    export PS4='+ ${BASH_SOURCE}:${LINENO}: '
    bash -x "$script_path" 2>>"$log_path"
}

# Function to generate coverage report
generate_report() {
    local log_path="$1"
    local report_path="$2"
    
    # Generate JSON report
    ts-node "$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)/coverage-tool/src/main.ts" \
        "$log_path" \
        "$report_path"
}

# If script is run directly (not loaded by BATS)
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    if [ $# -lt 2 ]; then
        echo "Usage: $0 <path-to-script> <path-to-bats-test>"
        exit 1
    fi

    SCRIPT_PATH="$1"
    BATS_PATH="$2"

    if [ ! -f "$SCRIPT_PATH" ]; then
        echo "Error: Script not found at '$SCRIPT_PATH'"
        exit 1
    fi

    # Handle BATS test path - if it's just a filename, look in current directory
    if [[ "$BATS_PATH" != /* ]] && [[ "$BATS_PATH" != ./* ]]; then
        BATS_PATH="./$BATS_PATH"
    fi

    if [ ! -f "$BATS_PATH" ]; then
        echo "Error: BATS test not found at '$BATS_PATH'"
        exit 1
    fi

    # Ensure .bats extension
    if [[ "${BATS_PATH##*.}" != "bats" ]]; then
        echo "Error: File must be a .bats test file"
        exit 1
    fi

    echo "Running coverage for: $SCRIPT_PATH"

    # Setup output directories
    ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
    LOG_PATH="$ROOT_DIR/coverage.log"
    REPORTS_DIR="$ROOT_DIR/coverage-reports"
    mkdir -p "$REPORTS_DIR"

    # Collect coverage
    collect_coverage "$SCRIPT_PATH" "$LOG_PATH"

    # Execute the BATS test (so coverage.log gets real traces)
    bats "$BATS_PATH"

    # Generate report
    generate_report "$LOG_PATH" "$REPORTS_DIR/coverage.json"
fi 