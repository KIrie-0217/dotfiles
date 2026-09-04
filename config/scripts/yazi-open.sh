#!/usr/bin/env bash
# yazi opener: open file in nvim pane (split from agent pane), reuse if already open
WS_ID="${HERDR_WORKSPACE_ID:-default}"
SOCKET="/tmp/nvim-yazi-${WS_ID}.sock"

# If nvim is already running, send file via --remote
if [ -S "$SOCKET" ] && nvim --server "$SOCKET" --remote-expr "1" &>/dev/null; then
  nvim --server "$SOCKET" --remote-tab -- "$@"
  exit 0
fi

# Prefer the pane ID supplied by hr. Fall back to herdr's agent metadata for
# workspaces created by other launchers.
AGENT_PANE="${HERDR_AGENT_PANE_ID:-}"
if [ -z "$AGENT_PANE" ]; then
  WS_FLAG=()
  [ -n "${HERDR_WORKSPACE_ID:-}" ] && WS_FLAG=(--workspace "$HERDR_WORKSPACE_ID")
  AGENT_PANE=$(herdr pane list "${WS_FLAG[@]}" 2>/dev/null \
    | jq -r '.result.panes[] | select(.agent != null and .agent != "") | .pane_id' | head -1)
fi
[ -z "$AGENT_PANE" ] && exec nvim -- "$@"

# Write a launch script with embedded file paths (avoids temp-file race)
LAUNCH="/tmp/herdr-nvim-launch.sh"
{
  echo '#!/usr/bin/env bash'
  printf 'exec nvim -p --listen %q --' "$SOCKET"
  for f in "$@"; do printf ' %q' "$f"; done
  echo
} > "$LAUNCH"
chmod +x "$LAUNCH"

# Split agent pane right (50/50)
NEW_PANE=$(herdr pane split "$AGENT_PANE" --direction right --ratio 0.5 2>/dev/null \
  | jq -r '.result.pane.pane_id // empty')
[ -z "$NEW_PANE" ] && exec nvim -- "$@"

herdr pane run "$NEW_PANE" "exec $LAUNCH"
