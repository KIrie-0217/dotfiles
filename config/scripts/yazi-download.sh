#!/usr/bin/env bash
# yazi-download.sh - Download file from SSH remote to local ~/Downloads via OSC 1337
# Works through WezTerm's terminal file transfer protocol (no reverse SSH needed)
set -euo pipefail

[ -z "${SSH_CONNECTION:-}" ] && echo "Not in SSH session" && exit 1

FILE="$1"
[ ! -f "$FILE" ] && echo "Not a file: $FILE" && exit 1

FILENAME=$(basename "$FILE")
FILESIZE=$(wc -c < "$FILE" | tr -d ' ')

printf '\033]1337;File=name=%s;size=%s;inline=0:' \
  "$(echo -n "$FILENAME" | base64)" \
  "$FILESIZE"
base64 < "$FILE"
printf '\a'

echo "Sent: $FILENAME ($FILESIZE bytes) -> local Downloads"
