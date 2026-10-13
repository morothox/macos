#!/usr/bin/env bash
# Filename: ~/github/dotfiles-latest/herdr/scripts/open-workspace.sh
# herdr-Pendant zu ThePrimeagens tmux-sessionizer: Workspace für ein
# Verzeichnis fokussieren oder neu anlegen. Label = Ordnername.
# Aufruf: open-workspace.sh <verzeichnis>

set -euo pipefail

dir="${1:?usage: open-workspace.sh <dir>}"
dir="${dir/#\~/$HOME}"
dir="$(cd "$dir" && pwd)"
label="$(basename "$dir")"
[ "$dir" = "$HOME" ] && label="~"
herdr="${HERDR_BIN_PATH:-herdr}"

ws_id=$("$herdr" workspace list |
  jq -r --arg l "$label" 'first(.result.workspaces[] | select(.label == $l) | .workspace_id) // empty')

if [ -n "$ws_id" ]; then
  "$herdr" workspace focus "$ws_id" >/dev/null
else
  "$herdr" workspace create --cwd "$dir" --label "$label" --focus >/dev/null
fi
