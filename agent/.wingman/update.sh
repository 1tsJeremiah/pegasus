#!/bin/bash
# Update .wingman/state.yml with source (server/local) and status

STATE_FILE="$(dirname "$0")/state.yml"
SOURCE="$1"
PHASE="$2"

if [[ -z "$SOURCE" || -z "$PHASE" ]]; then
  echo "Usage: $0 [local|server] \"message\""
  exit 1
fi

TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

mkdir -p "$(dirname "$STATE_FILE")"

cat > "$STATE_FILE" <<EOF_YAML
updated: "$TIMESTAMP"
source: "$SOURCE"
phase: "$PHASE"
EOF_YAML

echo "✅ Wingman state written to $STATE_FILE"
