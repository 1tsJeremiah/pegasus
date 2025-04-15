#!/bin/bash

HOOK_NAME="$1"
FROM="$2"
TO="$3"
PROJECT_DIR="$(pwd)"

HOOK_PATH=".wingman/hooks/$HOOK_NAME"

# Run hook if executable
if [[ -x "$HOOK_PATH" ]]; then
  "$HOOK_PATH" "$FROM" "$TO" "$PROJECT_DIR"
else
  echo "⚠️ Hook $HOOK_NAME not found or not executable"
fi

# Self-ping as agent
if command -v wingman &>/dev/null; then
  AGENT_NAME=$(hostname)
  wingman agent ping "$AGENT_NAME"
fi
