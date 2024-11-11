#!/bin/bash

# Usage: ./set_env_file.sh VAR_NAME VAR_VALUE ENV_FILE
VAR_NAME=$1
VAR_VALUE=$2
ENV_FILE=$3

if [[ -z "$VAR_NAME" || -z "$VAR_VALUE" || -z "$ENV_FILE" ]]; then
  echo "Usage: $0 VAR_NAME VAR_VALUE ENV_FILE"
  exit 1
fi

# Create the .env file if it doesn't exist
touch "$ENV_FILE"

# Check if the variable exists, update it if so, otherwise append it
if grep -q "^${VAR_NAME}=" "$ENV_FILE"; then
  # Update existing variable
  sed -i'' -e "s/^${VAR_NAME}=.*/${VAR_NAME}=${VAR_VALUE}/" "$ENV_FILE"
else
  # Append new variable
  echo "${VAR_NAME}=${VAR_VALUE}" >> "$ENV_FILE"
fi

echo "Set ${VAR_NAME}=${VAR_VALUE} in ${ENV_FILE}"

