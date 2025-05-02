#!/usr/bin/env bats

setup() {
    # Create necessary directories
    mkdir -p coverage-reports
    
    # Clean up any existing coverage files
    rm -f coverage.log
    rm -f coverage-reports/coverage.json
    rm -f executable_lines.log
}

@test "coverage tool generates coverage log" {
    # Run the coverage tool on a test script
    run bash coverage-tool/scripts/coverage.sh scripts/file_operations.sh
    
    # Debug output
    echo "Status: $status"
    echo "Output: $output"
    
    # Check if coverage.log was created
    [ -f "coverage.log" ]
}

@test "coverage tool generates report" {
    # First generate the coverage log
    run bash coverage-tool/scripts/coverage.sh scripts/file_operations.sh
    echo "Coverage log generation status: $status"
    
    # Generate the coverage report
    run npm run coverage:report
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
    # First generate the coverage log
    run bash coverage-tool/scripts/coverage.sh scripts/file_operations.sh
    echo "Coverage log generation status: $status"
    
    # Generate the coverage report
    run npm run coverage:report
    echo "Report generation status: $status"
    
    # Check if the report contains data for file_operations.sh
    run jq -r 'keys[]' coverage-reports/coverage.json
    echo "Report keys: $output"
    [ "$output" = "scripts/file_operations.sh" ]
} 