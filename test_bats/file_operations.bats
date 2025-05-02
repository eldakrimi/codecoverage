#!/usr/bin/env bats

# Define where the script lives and its name
CWD="scripts"
CMD="file_operations.sh"

# Setup - runs before each test
setup() {
    # Create a temporary directory for test files
    TEST_DIR="$(mktemp -d)"
    cd "$TEST_DIR"
    
    # Get absolute path to project root and source script
    PROJECT_ROOT="$(cd "$(dirname "$BATS_TEST_FILENAME")/.." && pwd)"
    source "$PROJECT_ROOT/$CWD/$CMD"
}

# Teardown - runs after each test
teardown() {
    # Clean up temporary directory
    cd -
    rm -rf "$TEST_DIR"
}

@test "Creating a file works correctly" {
    # Test file creation
    run create_file "test1.txt" "Hello World"
    
    # Assert command succeeded
    [ "$status" -eq 0 ]
    
    # Assert output message is correct
    [ "$output" = "Created file: test1.txt" ]

    # Assert file exists
    [ -f "test1.txt" ]
    
    # Assert file content is correct
    [ "$(cat test1.txt)" = "Hello World" ]
}

@test "Deleting an existing file works correctly" {
    # Create a test file
    create_file "test2.txt" "Test content"
    
    # Test file deletion
    run delete_file "test2.txt"
    
    # Assert command succeeded
    [ "$status" -eq 0 ]
    
    # Assert file no longer exists
    [ ! -f "test2.txt" ]
    
    # Assert output message is correct
    [ "${lines[0]}" = "Deleted file: test2.txt" ]
}

@test "Deleting a non-existent file shows appropriate message" {
    # Test deleting non-existent file
    run delete_file "nonexistent.txt"
    
    # Assert command succeeded
    [ "$status" -eq 0 ]
    
    # Assert output message is correct
    [ "${lines[0]}" = "File does not exist: nonexistent.txt" ]
}


