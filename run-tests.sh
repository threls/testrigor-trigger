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

# Construct the TestRigor API URL
API_URL="https://api.testrigor.com/api/v1/apps/$TEST_SUITE_KEY/retest"
# Make the API request
echo "Triggering TestRigor test suite execution..."
if ! command -v curl &> /dev/null; then
    echo "Error: curl is not installed"
    exit 1
fi

if ! command -v jq &> /dev/null; then
    echo "Error: jq is not installed"
    exit 1
fi

# Execute curl with verbose output to stderr
echo "Making API request to: $API_URL"
RESPONSE=$(curl -v -s -X POST \
    -H "auth-token: $TESTRIGOR_TOKEN" \
    -H "Content-type: application/json" \
    "$API_URL" 2>/tmp/curl_verbose.log)

# If the response is empty, check the verbose log
if [ -z "$RESPONSE" ]; then
    echo "Error: Empty response received"
    echo "Curl verbose output:"
    cat /tmp/curl_verbose.log
    exit 1
fi

# Check curl exit status
CURL_EXIT_CODE=$?
if [ $CURL_EXIT_CODE -ne 0 ]; then
    echo "Error: curl command failed with exit code $CURL_EXIT_CODE"
    echo "Response: $RESPONSE"
    echo "Curl verbose output:"
    cat /tmp/curl_verbose.log
    exit 1
fi

# Verify we got a valid JSON response
if ! echo "$RESPONSE" | jq . >/dev/null 2>&1; then
    echo "Error: Invalid JSON response received"
    echo "Raw response: $RESPONSE"
    exit 1
fi

# Extract and display the execution ID
EXECUTION_ID=$(echo "$RESPONSE" | jq -r '.taskId')
if [ -z "$EXECUTION_ID" ] || [ "$EXECUTION_ID" = "null" ]; then
    echo "Error: Failed to get execution ID from response"
    echo "Response: $RESPONSE"
    exit 1
fi

echo "Test suite execution triggered successfully!"
echo "Execution ID: $EXECUTION_ID"
echo "You can monitor the execution at: https://app.testrigor.com/test-suites/$TEST_SUITE_KEY/runs/$EXECUTION_ID" 
 