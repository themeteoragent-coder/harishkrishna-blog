#!/usr/bin/env bash
# One-time setup script — creates the GitHub repo and pushes everything
set -euo pipefail

REPO_NAME="harishkrishna-blog"
GH_USER="themeteoragent-coder"

echo "==> Creating GitHub repo: $GH_USER/$REPO_NAME"
gh repo create "$GH_USER/$REPO_NAME" --public --description "Personal blog — Hugo + GitHub Pages" || {
  echo "Could not create via gh CLI. Do it manually:"
  echo "  1. Go to https://github.com/new"
  echo "  2. Repository name: $REPO_NAME"
  echo "  3. Public, no template, no README/.gitignore/license"
  echo "  4. Click Create"
  echo ""
  echo "Then come back and run the push step below."
  exit 1
}

echo "==> Enabling GitHub Pages"
gh api "repos/$GH_USER/$REPO_NAME/pages" \
  --method POST \
  --field source='{"branch":"gh-pages","path":"/"}' \
  --silent 2>/dev/null || echo "(Pages will be configured via Actions workflow)"

echo "==> Pushing site"
cd "$(dirname "$0")/.."
git remote add origin "https://github.com/$GH_USER/$REPO_NAME.git"
git add -A
git commit -m "🚀 Initial commit: Hugo blog with PaperMod theme"
git push -u origin main

echo ""
echo "✅ Repo created and pushed!"
echo ""
echo "Next steps (one-time):"
echo "  1. In GitHub repo → Settings → Pages"
echo "     - Source: GitHub Actions (should auto-detect the workflow)"
echo "  2. Add custom domain: harishkrishna.me"
echo "     - DNS: create a CNAME from harishkrishna.me → <$GH_USER>.github.io"
echo "     - OR an ANAME/ALIAS record pointing to GitHub Pages IPs"
echo "  3. Wait for DNS to propagate, enable HTTPS enforcement"
echo "  4. Done — your site is live at https://harishkrishna.me"
