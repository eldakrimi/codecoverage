#!/bin/bash

echo "Running BATS tests..."
echo "====================="

# Run each test file individually
for test_file in test_bats/*.bats; do
    echo "Running $test_file..."
    bats -t "$test_file"
    if [ $? -ne 0 ]; then
        echo "❌ Tests in $test_file failed!"
        exit 1
    fi
done

echo ""
echo "Test Results:"
echo "============"
echo "✅ All tests passed!" 