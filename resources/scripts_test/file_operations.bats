#!/usr/bin/env bats

load coverage.sh

# Define where the script lives and its name
CWD="../scripts"
CMD="file_operations.sh"

@test "Creating a file and delete it" {
    cd "$CWD"
    # Test file creation
    run "./$CMD"
    
    # Assert command succeeded
    [ "$status" -eq 0 ]
    
    # Assert output contains expected messages
    [[ "$output" == *"Created file: test.txt"* ]]
    [[ "$output" == *"Deleted file: test.txt"* ]]
}



