#!/bin/bash
# Auto-deploy wrapper triggered by macOS LaunchAgent on index.html changes.
# Adds debouncing and logging on top of deploy.sh.

PROJECT_DIR="/Users/spencerpede/Documents/Claude/Projects/Sports League Aggregator"
LOG="/tmp/leaguelookup-deploy.log"
LOCK="/tmp/leaguelookup-deploy.lock"

cd "$PROJECT_DIR" || exit 1

# Bail if another deploy is already running (prevents double-fires)
if [ -f "$LOCK" ]; then
  echo "[$(date '+%F %T')] Skipped: deploy already in progress" >> "$LOG"
  exit 0
fi
touch "$LOCK"
trap 'rm -f "$LOCK"' EXIT

# Debounce — wait a couple seconds for any rapid sequential edits to settle
sleep 3

# Use full PATH so git is found
export PATH="/usr/local/bin:/usr/bin:/bin:/opt/homebrew/bin:$PATH"

# Stage everything that might have changed
git add -A

# Skip if nothing actually changed
if git diff --cached --quiet; then
  echo "[$(date '+%F %T')] No changes to deploy" >> "$LOG"
  exit 0
fi

MSG="Auto-deploy: $(date '+%Y-%m-%d %H:%M:%S')"

{
  echo "[$(date '+%F %T')] Deploying..."
  git commit -m "$MSG"
  git push
  echo "[$(date '+%F %T')] Done."
  echo "---"
} >> "$LOG" 2>&1
