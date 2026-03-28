#!/usr/bin/env bash
# DB myth monitor – runs at 06:00 UTC (includes misinformation detection)
# Searches the web for recent mentions of PostgreSQL, MongoDB, Oracle that discuss myths, misconceptions, comparative anecdotes, or potentially incorrect statements.

SEEN_FILE="$(dirname "$(realpath "$0")")/../mentions_db_seen.json"
if [ ! -f "$SEEN_FILE" ]; then
  echo "[]" > "$SEEN_FILE"
fi

openclaw sessions spawn \
  --task "Search the public web for the last 24 hours for mentions of PostgreSQL, MongoDB, or Oracle that discuss myths, misconceptions, comparative anecdotes, or potentially incorrect statements (including posts that may be misinformation even if not flagged as a myth). Return up to 5 new URLs not present in $SEEN_FILE. Update $SEEN_FILE with any newly reported URLs. Send the resulting summary as a Telegram message to the user (Franck)." \
  --runTimeoutSeconds 300