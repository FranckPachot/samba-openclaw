#!/usr/bin/env bash
# Daily mention checker – runs at 07:00 UTC
# Uses OpenClaw to spawn a sub‑agent that searches the web and social platforms
# and reports any new URLs (max 10) that haven't been seen before.

# Path to the JSON file that stores already‑reported links
SEEN_FILE="$(dirname "$(realpath "$0")")/../mentions_seen.json"

# Ensure the file exists
if [ ! -f "$SEEN_FILE" ]; then
  echo "[]" > "$SEEN_FILE"
fi

# Spawn a sub‑agent to perform the searches and send you a message.
# The sub‑agent will read the SEEN_FILE, update it, and return the summary.
openclaw sessions spawn \
  --task "Search for public mentions of Franck Pachot on the generic web, LinkedIn, Twitter, Bluesky and Mastodon. Return up to 10 new links (not present in $SEEN_FILE). Update $SEEN_FILE with any newly reported URLs. Send the resulting summary as a Telegram message to the user." \
  --runTimeoutSeconds 300
