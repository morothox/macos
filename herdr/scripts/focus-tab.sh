#!/usr/bin/env bash
# Filename: ~/github/dotfiles-latest/herdr/scripts/focus-tab.sh
# Fokussiert Tab Nummer N im aktiven Workspace (tmux: select-window -t N).
# Aufruf aus herdr [[keys.command]] type="shell": focus-tab.sh <N>

set -euo pipefail

n="${1:?usage: focus-tab.sh <N>}"
herdr="${HERDR_BIN_PATH:-herdr}"
ws_args=()
[ -n "${HERDR_ACTIVE_WORKSPACE_ID:-}" ] && ws_args=(--workspace "$HERDR_ACTIVE_WORKSPACE_ID")

tab_id=$("$herdr" tab list "${ws_args[@]}" |
  jq -r --argjson n "$n" '.result.tabs[] | select(.number == $n) | .tab_id')

[ -n "$tab_id" ] && "$herdr" tab focus "$tab_id" >/dev/null
