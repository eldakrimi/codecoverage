#!/usr/bin/env bats

# Load the script to test
load ../scripts/file_operations.sh

# Setup - runs before each test
setup() {
    # Create a temporary directory for test files
    TEST_DIR="$(mktemp -d)"
    cd "$TEST_DIR"
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
    
    # Assert file exists
    [ -f "test1.txt" ]
    
    # Assert file content is correct
    [ "$(cat test1.txt)" = "Hello World" ]
    
    # Assert output message is correct
    [ "${lines[0]}" = "Created file: test1.txt" ]
}

@test "Deleting an existing file works correctly" {
    # Create a test file first
    echo "test content" > "test2.txt"
    
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
    
    # Assert command succeeded (should not error)
    [ "$status" -eq 0 ]
    
    # Assert appropriate message
    [ "${lines[0]}" = "File does not exist: nonexistent.txt" ]
}

@test "Creating and then deleting a file works correctly" {
    # Create file
    run create_file "test3.txt" "Test content"
    [ "$status" -eq 0 ]
    [ -f "test3.txt" ]
    
    # Delete file
    run delete_file "test3.txt"
    [ "$status" -eq 0 ]
    [ ! -f "test3.txt" ]
} 