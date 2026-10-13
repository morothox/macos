#!/usr/bin/env bash
# Filename: ~/github/dotfiles-latest/herdr/install-plugins.sh
# herdr-Plugins (wie TPM beim tmux). Idempotent: bereits installierte werden
# übersprungen. Updates/Verwaltung danach: prefix+I (ray.plugin-manager).
# Plugins laufen ungesandboxt als dein User – nur vertrauenswürdige eintragen.
# Build-Abhängigkeiten: go (sesh), cargo (sidebar, Fallback), node (resurrect), fzf, jq

set -euo pipefail

plugins=(
  "fullerzz/herdr-plugin-sesh"                     # fullerzz.sesh – sesh-Picker + zoxide
  "ntindle/herdr-resurrect"                        # tmux-resurrect/continuum: Autosave + Restore
  "lmilojevicc/herdr-splits.nvim"                  # vim-tmux-navigator: C-hjkl durch nvim + Panes
  "alexarthurs/herdr-sidebar/plugins/herdr-sidebar" # Dateibaum + Git-Sidebar
  "qu8n/herdr-automatic-rename"                    # Tabs nach Prozess/Agent benennen
  "speardragon/herdr-plugin-manager"               # TPM-artiger Manager (Popup)
  "JanTvrdik/herdr-command-palette"                # fzf-Palette über alle Plugin-Actions
)

installed=$(herdr plugin list 2>/dev/null || true)

for p in "${plugins[@]}"; do
  if grep -qF "github:${p}@" <<<"$installed"; then
    echo "✓ $p"
  else
    echo "→ installing $p"
    herdr plugin install "$p" --yes
  fi
done

herdr server reload-config >/dev/null 2>&1 || true
