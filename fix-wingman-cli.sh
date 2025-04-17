#!/bin/bash

# Set project path
PROJECT_DIR=~/projects/pegasus/wingman

echo "🔧 Re-linking Wingman to Node CLI..."

# Remove old wingman binary (if it exists)
rm -f ~/.local/bin/wingman

# Link current Node CLI
cd "$PROJECT_DIR"
npm link

echo "✅ Wingman Node CLI is now globally available"
echo "👉 Try: wingman next"
