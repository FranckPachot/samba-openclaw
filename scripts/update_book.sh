#!/usr/bin/env bash
set -e
# Navigate to workspace root (parent of this script's directory)
cd "$(dirname "${BASH_SOURCE[0]}")/.."
BOOK="BOOK.md"
if [ ! -f "$BOOK" ]; then
  echo "$BOOK not found" >&2
  exit 1
fi
# Extract chapter titles from INSTRUCTIONS.md (markdown headings)
INSTR="INSTRUCTIONS.md"
if [ ! -f "$INSTR" ]; then
  echo "$INSTR not found" >&2
  exit 1
fi
mapfile -t chapters < <(grep -E '^#{1,6} ' "$INSTR" | sed -E 's/^#{1,6} //')
if [ ${#chapters[@]} -eq 0 ]; then
  echo "No chapters found in $INSTR" >&2
  exit 1
fi
# Pick a random chapter
RANDOM_INDEX=$((RANDOM % ${#chapters[@]}))
CHAPTER="${chapters[$RANDOM_INDEX]}"
# Simple typo/grammar fixes on the whole INSTRUCTIONS.md (e.g., common "teh" typo)
sed -i -e 's/\bteh\b/the/g' -e 's/  / /g' "$INSTR"
# Append a brief update note to the BOOK.md about this chapter review
NOW=$(date -u '+%Y-%m-%d %H:%M UTC')
UPDATE_SECTION="\n## Update $(date '+%Y-%m-%d')\n- Reviewed chapter from INSTRUCTIONS.md: $CHAPTER\n- Fixed simple typos on $NOW\n"
echo -e "$UPDATE_SECTION" >> "$BOOK"
# Commit changes to git with a short description (both files)
git add "$BOOK" "$INSTR"
git commit -m "Review $CHAPTER and fix typos on $NOW"
