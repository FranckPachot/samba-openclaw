#!/usr/bin/env bash
set -e
# Navigate to workspace root (parent of this script's directory)
cd "$(dirname "${BASH_SOURCE[0]}")/.."
BOOK="BOOK.md"
if [ ! -f "$BOOK" ]; then
  echo "$BOOK not found" >&2
  exit 1
fi
# Extract chapter titles (markdown headings)
mapfile -t chapters < <(grep -E '^#{1,6} ' "$BOOK" | sed -E 's/^#{1,6} //')
if [ ${#chapters[@]} -eq 0 ]; then
  echo "No chapters found in $BOOK" >&2
  exit 1
fi
# Pick a random chapter
RANDOM_INDEX=$((RANDOM % ${#chapters[@]}))
CHAPTER="${chapters[$RANDOM_INDEX]}"
# Placeholder: Append a brief update note to the BOOK.md
NOW=$(date -u '+%Y-%m-%d %H:%M UTC')
UPDATE_SECTION="\n## Update $(date '+%Y-%m-%d')\n- Reviewed chapter: $CHAPTER\n- Added notes on $NOW\n"
echo -e "$UPDATE_SECTION" >> "$BOOK"
# Commit changes to git with a short description
git add "$BOOK"
git commit -m "Update $CHAPTER on $NOW"
