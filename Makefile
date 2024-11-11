.PHONY: set-env test-set-env

# Default help command
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

set-ts-key-public-proxy: ## Set a public ts key
	@make set-env VAR=TS_AUTHKEY VALUE=$(VALUE) ENV_FILE=./docker/.env

set-env: ## Set environment variable in a specified .env file
	@if [ -z "$(VAR)" ] || [ -z "$(VALUE)" ] || [ -z "$(ENV_FILE)" ]; then \
		echo "Usage: make set-env VAR=<variable_name> VALUE=<new_value> ENV_FILE=<path_to_env_file>"; \
		exit 1; \
	fi
	@bash scripts/set_env_file.sh "$(VAR)" "$(VALUE)" "$(ENV_FILE)"

test-set-env: ## Run tests on set_env_file.sh script
	@bash scripts/tests/test_set_env_file.sh
