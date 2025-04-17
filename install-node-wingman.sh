#!/bin/bash

set -e

echo "🔧 Switching to Node-based Wingman CLI..."

# Step 1: Remove old Bash version if present
if [[ -f "$HOME/.local/bin/wingman" ]]; then
  echo "⚠️  Removing old Bash wingman from ~/.local/bin"
  rm -f "$HOME/.local/bin/wingman"
fi

# Step 2: Ensure wingman CLI folder exists
cd "$HOME/projects/pegasus/wingman" || { echo "❌ Could not find wingman directory"; exit 1; }

# Step 3: Install dependencies if needed
if [[ ! -d "node_modules" ]]; then
  echo "📦 Installing dependencies..."
  npm install
fi

# Step 4: Link Node CLI globally
echo "🔗 Linking Node CLI globally..."
npm link

# Step 5: Test it
echo "🧪 Testing CLI with 'wingman next'..."
wingman next || echo "❌ Something went wrong running wingman next"

echo "✅ Done. You can now run:"
echo "    wingman next"
echo "    wingman change <phase>"
