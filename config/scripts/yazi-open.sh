#!/usr/bin/env bash
# yazi opener: open file in existing nvim (via --remote) or new right pane
SOCKET="/tmp/nvim-yazi.sock"
FILE="$1"

if [ -S "$SOCKET" ] && nvim --server "$SOCKET" --remote-expr "1" &>/dev/null; then
  nvim --server "$SOCKET" --remote "$FILE"
else
  zellij run --direction right --name "nvim" -- nvim --listen "$SOCKET" "$FILE"
fi
