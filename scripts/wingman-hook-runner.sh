#!/bin/bash

HOOK_NAME="$1"
FROM="$2"
TO="$3"
PROJECT_DIR="$(pwd)"
HOOK_PATH=".wingman/hooks/$HOOK_NAME"

# Run base hook if available
if [[ -x "$HOOK_PATH" ]]; then
  "$HOOK_PATH" "$FROM" "$TO" "$PROJECT_DIR"
fi

# Agent-aware task runner
AGENT_NAME=$(hostname)
TASK_PATH=".wingman/tasks/$TO.sh"
LOG_PATH=".wingman/task-logs/${AGENT_NAME}.log"

if grep -q "$TO" ".wingman/agents/$AGENT_NAME.yml"; then
  if [[ -x "$TASK_PATH" ]]; then
    echo "[agent:$AGENT_NAME] Running task: $TO" >> "$LOG_PATH"
    bash "$TASK_PATH" >> "$LOG_PATH" 2>&1
  else
    echo "[agent:$AGENT_NAME] No task script for phase: $TO" >> "$LOG_PATH"
  fi
fi

# Self-ping
if command -v wingman &>/dev/null; then
  wingman agent ping "$AGENT_NAME"
fi
