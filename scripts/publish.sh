#!/usr/bin/env bash
# Copies content from Obsidian vault → blog repo → commits → pushes
set -euo pipefail

VAULT_CONTENT=~/Documents/"Harish's Vault"/"Harish's Hive"/Blog
REPO=~/Documents/harishkrishna-blog

echo "📂 Syncing content from Hive to repo..."
rsync -a --delete "$VAULT_CONTENT/" "$REPO/content/"

cd "$REPO"

echo "🔎 Checking post dates..."
python3 - <<'PY' || { echo "❌ Aborting before build — fix the dates above and re-run."; exit 1; }
import datetime, glob, sys

now = datetime.datetime.now(datetime.timezone.utc)
SKEW = datetime.timedelta(minutes=2)


def parse(raw):
    v = raw.strip().strip('"\'')
    if not v:
        return None
    try:
        dt = datetime.datetime.fromisoformat(v.replace('Z', '+00:00'))
    except ValueError:
        return None
    if dt.tzinfo is None:
        dt = dt.replace(tzinfo=datetime.timezone.utc)
    return dt


future, unparsed = [], []
for path in sorted(glob.glob('content/**/*.md', recursive=True)):
    text = open(path, encoding='utf-8').read()
    if not text.lstrip().startswith('---'):
        continue
    parts = text.split('---', 2)
    if len(parts) < 3:
        continue
    draft, date_raw = False, None
    for line in parts[1].splitlines():
        key, _, val = line.partition(':')
        key = key.strip().lower()
        if key == 'draft':
            draft = val.strip().strip('"\'').lower() in ('true', 'yes')
        elif key == 'date':
            date_raw = val
    if draft or date_raw is None:
        continue
    dt = parse(date_raw)
    if dt is None:
        unparsed.append((path, date_raw.strip()))
    elif dt > now + SKEW:
        future.append((path, date_raw.strip(), (dt - now).total_seconds() / 3600))

for path, raw in unparsed:
    print(f"   ⚠️  unparseable date in {path}: {raw!r}")

if future:
    print()
    for path, raw, hours in future:
        print(f"   ❌ {path}\n      date: {raw}  → {hours:+.1f}h from now")
    print()
    print("   Hugo silently drops future-dated posts: the build goes green and the post")
    print("   never appears live. Set date: to now (IST, +05:30) or earlier, then re-run.")
    sys.exit(1)

print("   ✅ all non-draft posts dated in the past")
PY

echo "🏗️  Building site..."
hugo --minify

echo "📤 Committing and pushing..."
git add -A
git commit -m "Publish: $(date '+%Y-%m-%d %H:%M')" || echo "   Nothing to commit"
git push

echo "✅ Published!"
