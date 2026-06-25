#!/usr/bin/env bash
# yazi opener: open file in existing nvim (via --remote) or new right pane (herdr)
SOCKET="/tmp/nvim-yazi.sock"
FILE="$1"

if [ -S "$SOCKET" ] && nvim --server "$SOCKET" --remote-expr "1" &>/dev/null; then
  nvim --server "$SOCKET" --remote "$FILE"
else
  herdr pane split --direction right --ratio 0.8 --current --command "nvim --listen $SOCKET $FILE" --close-on-exit
fi
