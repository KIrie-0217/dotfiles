#!/usr/bin/env bash
# Wrapper: run nvim with server socket, pane auto-closes on exit
SOCKET="/tmp/nvim-yazi.sock"
ARGS_FILE="/tmp/herdr-yazi-nvim-args"

mapfile -t FILES < "$ARGS_FILE"
rm -f "$ARGS_FILE"

nvim --listen "$SOCKET" "${FILES[@]}"
rm -f "$SOCKET"
