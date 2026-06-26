#!/usr/bin/env bash
# yazi opener: open file in nvim pane (split from agent pane), reuse if already open
SOCKET="/tmp/nvim-yazi.sock"

# If nvim is already running, send file via --remote
if [ -S "$SOCKET" ] && nvim --server "$SOCKET" --remote-expr "1" &>/dev/null; then
  nvim --server "$SOCKET" --remote "$@"
  exit 0
fi

# Find the agent pane (left neighbor of yazi)
AGENT_PANE=$(herdr pane neighbor --direction left --current 2>/dev/null \
  | jq -r '.result.pane.pane_id // empty')
[ -z "$AGENT_PANE" ] && exec nvim "$@"

# Pass file paths to wrapper via temp file (handles spaces in paths)
printf '%s\n' "$@" > /tmp/herdr-yazi-nvim-args

# Split agent pane right: agent keeps 40% (~34% of total), nvim gets 60% (~51% of total)
herdr pane split "$AGENT_PANE" --direction right --ratio 0.4 --close-on-exit \
  --command "yazi-nvim-wrapper.sh" >/dev/null 2>&1
