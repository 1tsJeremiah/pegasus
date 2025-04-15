#!/bin/bash

# Wingman Thread State Sync
# Usage: ./update.sh [thread] [phase] [author]

THREAD=${1:-local}
PHASE=${2:-bootstrap}
AUTHOR=${3:-$(whoami)}
LAST_COMMIT=$(git rev-parse --short HEAD)

mkdir -p .wingman

cat > .wingman/state.yml <<EOF
project: Pegasus
thread: $THREAD
author: $AUTHOR
phase: $PHASE
last_commit: $LAST_COMMIT
status:
  server: synced
  local: behind
  github: synced
agents:
  - name: serVAgent
    status: planned
  - name: wingman
    status: active
next_tasks:
  - setup: vector DB container
  - action: implement GPT Actions Read
notes: |
  Auto-generated status by Wingman CLI helper.
  Thread updated: $THREAD, phase: $PHASE
EOF

echo "✅ Wingman state written to .wingman/state.yml"
