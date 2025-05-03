#!/usr/bin/env bats

# Load coverage functions
load coverage.sh

setup() {
    # Create necessary directories
    mkdir -p coverage-reports
    
    # Clean up any existing coverage files
    rm -f coverage.log
    rm -f coverage-reports/coverage.json
    rm -f executable_lines.log
}

@test "coverage tool generates coverage log" {
    # Get script path
    SCRIPT_PATH="$(cd "$(dirname "$BATS_TEST_FILENAME")/../.." && pwd)/resources/scripts/file_operations.sh"
    
    # Run the coverage tool
    run collect_coverage "$SCRIPT_PATH" "coverage.log"
    
    # Debug output
    echo "Status: $status"
    echo "Output: $output"
    
    # Check if coverage.log was created
    [ -f "coverage.log" ]
}

@test "coverage tool generates report" {
    # Get script path
    SCRIPT_PATH="$(cd "$(dirname "$BATS_TEST_FILENAME")/../.." && pwd)/resources/scripts/file_operations.sh"
    
    # First generate the coverage log
    run collect_coverage "$SCRIPT_PATH" "coverage.log"
    echo "Coverage log generation status: $status"
    
    # Generate the coverage report
    run generate_report "coverage.log" "coverage-reports/coverage.json"
    echo "Report generation status: $status"
    echo "Report generation output: $output"
    
    # Check if the report was created
    [ -f "coverage-reports/coverage.json" ]
    
    # Check if the report contains valid JSON
    run jq '.' coverage-reports/coverage.json
    echo "JSON validation status: $status"
    [ "$status" -eq 0 ]
}

@test "coverage report contains expected data" {
    # Get script path
    SCRIPT_PATH="$(cd "$(dirname "$BATS_TEST_FILENAME")/../.." && pwd)/resources/scripts/file_operations.sh"
    
    # First generate the coverage log
    run collect_coverage "$SCRIPT_PATH" "coverage.log"
    echo "Coverage log generation status: $status"
    
    # Generate the coverage report
    run generate_report "coverage.log" "coverage-reports/coverage.json"
    echo "Report generation status: $status"
    
    # Check if the report contains data for file_operations.sh
    run jq -r 'keys[]' coverage-reports/coverage.json
    echo "Report keys: $output"
    [ "$output" = "$SCRIPT_PATH" ]
} 