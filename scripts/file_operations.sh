#!/bin/bash

# Function to create a file
create_file() {
    local filename=$1
    local content=$2
    
    echo "$content" > "$filename"
    echo "Created file: $filename"
}

# Function to delete a file
delete_file() {
    local filename=$1
    
    if [ -f "$filename" ]; then
        rm "$filename"
        echo "Deleted file: $filename"
    else
        echo "File does not exist: $filename"
    fi
}

# Example usage
echo "Starting file operations..."

# Create a test file
create_file "test.txt" "This is a test file created by the script."

# Wait for 2 seconds
sleep 2

# Delete the test file
delete_file "test.txt"

echo "File operations completed." 