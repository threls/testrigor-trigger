#!/bin/bash

# Exit on error
set -e

# Check if required environment variables are set
if [ -z "$TESTRIGOR_TOKEN" ]; then
    echo "Error: TESTRIGOR_TOKEN is not set"
    exit 1
fi

if [ -z "$TEST_SUITE_KEY" ]; then
    echo "Error: TEST_SUITE_KEY is not set"
    exit 1
fi

# Read and validate JSON data
if [ ! -f "/tmp/input.json" ]; then
    echo "Error: JSON data file not found"
    exit 1
fi

# Construct the TestRigor API URL
API_URL="https://api.testrigor.com/api/v1/test-suites/$TEST_SUITE_KEY/retest"

# Make the API request
echo "Triggering TestRigor test suite execution..."
RESPONSE=$(curl -s -X POST \
    -H "auth-token: $TESTRIGOR_TOKEN" \
    -H "Content-Type: application/json" \
    -d @/tmp/input.json \
    "$API_URL")

# Check if the request was successful
if [ $? -ne 0 ]; then
    echo "Error: Failed to trigger test suite execution"
    exit 1
fi

# Extract and display the execution ID
EXECUTION_ID=$(echo "$RESPONSE" | jq -r '.executionId')
if [ "$EXECUTION_ID" = "null" ]; then
    echo "Error: Failed to get execution ID from response"
    echo "Response: $RESPONSE"
    exit 1
fi

echo "Test suite execution triggered successfully!"
echo "Execution ID: $EXECUTION_ID"
echo "You can monitor the execution at: https://app.testrigor.com/executions/$EXECUTION_ID" 