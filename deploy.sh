#!/bin/bash
# League Lookup deploy script
# Usage:
#   ./deploy.sh                       — pushes with auto-generated commit message
#   ./deploy.sh "your message here"   — pushes with custom message

set -e

cd "$(dirname "$0")"

# Use provided commit message, or auto-generate one with a timestamp
MSG="${1:-Update site $(date '+%Y-%m-%d %H:%M')}"

# Stage any changes
git add -A

# Bail out cleanly if nothing changed
if git diff --cached --quiet; then
  echo "No changes to deploy."
  exit 0
fi

git commit -m "$MSG"
# -u sets upstream the first time, no-op on subsequent runs
git push -u origin main

echo ""
echo "Deployed. Site will update at https://leaguelookup.org in ~30 seconds."
