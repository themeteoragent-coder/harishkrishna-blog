#!/usr/bin/env bash
# Copies content from Obsidian vault → blog repo → commits → pushes
set -euo pipefail

VAULT_CONTENT=~/Documents/"Harish's Vault"/"Harish's Hive"/Blog
REPO=~/Documents/harishkrishna-blog

echo "📂 Syncing content from Hive to repo..."
rsync -a --delete "$VAULT_CONTENT/" "$REPO/content/"

cd "$REPO"

echo "🏗️  Building site..."
hugo --minify

echo "📤 Committing and pushing..."
git add -A
git commit -m "Publish: $(date '+%Y-%m-%d %H:%M')" || echo "   Nothing to commit"
git push

echo "✅ Published!"
