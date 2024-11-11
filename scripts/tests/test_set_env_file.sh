#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
# Paths to the script and the test .env file
SET_ENV_SCRIPT="$SCRIPT_DIR/../set_env_file.sh"
TEST_ENV_FILE=".env.test"

# Cleanup function
cleanup() {
  rm -f "$TEST_ENV_FILE"
  echo "Cleaned up test environment file."
}

# Test function
run_test() {
  local var_name=$1
  local var_value=$2
  local expected_value="$var_name=$var_value"

  # Run set_env_file.sh with the provided variable and value
  "$SET_ENV_SCRIPT" "$var_name" "$var_value" "$TEST_ENV_FILE"

  # Verify the result
  if grep -q "^$expected_value" "$TEST_ENV_FILE"; then
    echo "Test passed: $expected_value found in $TEST_ENV_FILE"
  else
    echo "Test failed: $expected_value not found in $TEST_ENV_FILE"
    cleanup
    exit 1
  fi
}

# Run tests
echo "Starting tests..."
echo "TEST_VAR=old_value" > "$TEST_ENV_FILE"
run_test "TEST_VAR" "new_value"  # Update existing variable
run_test "NEW_VAR" "another_value"  # Add new variable
run_test "TEST_VAR" "another_update" # Update again

# Clean up after tests
cleanup
echo "All tests passed!"

