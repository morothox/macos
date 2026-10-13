---
name: dotfiles
description: Dotfiles des Nutzers in ~/github/dotfiles-latest (nvim/LazyVim, zsh, tmux, kitty, ghostty, yabai, skhd, aerospace, sketchybar, starship, yazi, karabiner, colorschemes, brew). MUSS bei jeder Frage oder Änderung an Terminal-, Editor-, Shell-, Window-Manager- oder App-Konfiguration auf diesem Mac verwendet werden, egal aus welchem Verzeichnis.
---

# Dotfiles (macOS, Apple Silicon)

Repo: `~/github/dotfiles-latest` (Remote `git@github.com:morothox/macos.git`, Branch `main`). Fork der Dotfiles von linkarzu; Kommentare im Code teils Englisch (Original), eigene Ergänzungen Deutsch.

## Arbeitsweise

- Selbstständig handeln: Config lesen, ändern, neu laden, verifizieren. Nicht nachfragen bei normalen Config-Änderungen, Plugin-Tweaks, Keymaps, Optionen, Reloads.
- IMMER im Repo editieren, nie im Symlink-Ziel eine Kopie anlegen. `~/.config/<app>` ist fast immer ein Symlink ins Repo (siehe Tabelle).
- Bestehenden Stil der Datei übernehmen (LazyVim-Plugin-Specs unter `lua/plugins/*.lua`, ein Plugin bzw. Thema pro Datei).
- Nach Änderung verifizieren (siehe „Verifizieren“), dann kurz sagen, was geändert wurde.
- Ausnahmen, die trotzdem vorher gefragt werden: `git push`/Force-Operationen, Löschen ganzer Verzeichnisse, Änderungen an Secrets.
- Nicht committen, außer der Nutzer sagt es. Das Repo hat oft viele uncommittete Änderungen (Colorscheme-Wechsel schreiben Dateien um) – die gehören dem Nutzer, nicht anfassen oder zurücksetzen.

## Secrets

- `zshrc/zshrc-secrets.sh` enthält API-Keys, ist gitignored. NIE lesen, ausgeben oder committen. Neue Secrets dort nur per Key-Name referenzieren.

## Symlinks (aktiv)

| Pfad | Ziel im Repo |
|---|---|
| `~/.config/nvim` | `neovim/lazyvim/` (aktive Neovim-Config) |
| `~/.zshrc` | `zshrc/zshrc-file.sh` → sourct `zshrc-common.sh`, `zshrc-macos.sh`, `zshrc-secrets.sh` |
| `~/.tmux.conf` | `tmux/tmux.conf.sh` |
| `~/.vimrc` | `vimrc/vimrc-file` |
| `~/.bashrc` | `bashrc/bashrc-file.sh` |
| `~/.config/kitty`, `ghostty`, `rio` | `kitty/`, `ghostty/`, `rio/` |
| `~/.config/yabai`, `skhd`, `aerospace` | `yabai/`, `skhd/`, `aerospace/` |
| `~/.config/sketchybar` | `sketchybar/felixkratz-linkarzu/` |
| Starship | `starship-config/active-config.toml` via `STARSHIP_CONFIG` in `zshrc-macos.sh` (generiert von `colorscheme-set.sh`; `~/.config/starship.toml` ist ein toter Symlink, ungenutzt) |
| `~/.config/yazi`, `btop`, `fastfetch`, `sesh`, `karabiner`, `neovide`, `opencode`, `emacs` | gleichnamige Ordner |
| `~/.config/herdr/config.toml` (nur die Datei!) | `herdr/config.toml` – Ordner selbst enthält Sockets, Logs, Session, Plugins und bleibt lokal |
| `~/.omp/agent/skills/dotfiles` | `omp/skills/dotfiles/` (dieser Skill) |

Unsicher, ob etwas verlinkt ist: `readlink ~/.config/<app>`. Neue App-Config: Ordner im Repo anlegen, dann `ln -s ~/github/dotfiles-latest/<app> ~/.config/<app>`.

Weitere Neovim-Configs (nicht aktiv, nur per `NVIM_APPNAME`): `neovim/neobean`, `kickstart.nvim`, `quarto-nvim-kickstarter`.

## Neovim (LazyVim)

- Einstieg `init.lua` → `lua/config/lazy.lua`; eigene Optionen `lua/config/options.lua`, Autocmds `autocmds.lua`, Keymaps `keymaps.lua`.
- Hauptnutzung: Org-Notizen für die Schule (`~/orgfiles`). Relevante Dateien: `lua/plugins/orgmode.lua` (orgmode, blink.cmp-Quellen, LuaSnip-Snippets), `org-roam.lua`, `image.lua`, `ftplugin/org.lua` (Spell de+en, Word-artige Keymaps, Abkürzungen), `config/latex.lua`.
- Completion: blink.cmp. Für Org: orgmode, spell, dictionary (`dictionaries/de.txt` + `words.txt`, via fzf async), buffer, snippets, emoji, path.
- Performance-Falle: deutsches `spellsuggest()` blockiert synchron 1,5–4 s pro Wort. Der `spell`-Provider ist deshalb auf manuelles Auslösen (`<C-Space>`) beschränkt. Nicht wieder auf Auto stellen.
- Harper-LSP ist deaktiviert (`disable-harper.lua`). Mason: `mason-nvim.lua`.
- Plugin-Versionen: `lazy-lock.json`; Plugin-Quellcode liegt in `~/.local/share/nvim/lazy/<plugin>` (zum Nachlesen von Optionen).
- Spell-Dateien: `~/.local/share/nvim/site/spell/` (`de.utf-8.spl`, `de.utf-8.sug`).

## Colorschemes

Zentral gesteuert: `colorscheme/colorscheme-selector.sh` (fzf-Auswahl) → `zshrc/colorscheme-set.sh` schreibt die aktiven Dateien für kitty, ghostty, btop, starship, nvim (`lua/config/active-colorscheme.sh`) und Wallpaper. Farben nicht in einzelnen Apps hardcoden, sondern über `colorscheme/list/*.sh`.

### Backdrop-Sync (Farben automatisch aus dem Wallpaper)

Aktives Profil ist `backdrop-sync.sh` (in `colorscheme/colorscheme-vars.sh`). Ablauf:

1. LaunchAgent `~/Library/LaunchAgents/com.morothox.backdropsync.plist` startet alle 10 s `scripts/backdrop-sync.sh` (Logs: `/tmp/backdrop-sync.{out,err}.log`).
2. `backdrop-sync.sh` ermittelt das Wallpaper: per `lsof` auf die Prozesse `BackdropWallpaper`/`Backdrop` (Live-Wallpaper .mov/.mp4/Bilder), Fallback Finder-Desktopbild via `osascript`.
3. Vergleich mit `~/.cache/backdrop-sync/last-wallpaper`; unverändert → Abbruch (außer `--force`).
4. Video → ein Frame per `scripts/extract_frame` (kompiliertes Binary, gitignored) nach `~/.cache/backdrop-sync/current_frame.png`.
5. `scripts/backdrop-sync.py` (Homebrew-python3, Pillow, numpy, scipy): K-Means mit 8 Clustern auf 150px-Thumbnail. Häufigste Farbe liefert den Hue für Hintergrund (L 6 %) und Vordergrund (L 90 %) plus Abstufungen (Lualine, Codeblock, Cursorline, tmux). Die 8 Cluster werden auf lesbare L/S normalisiert, nach Hue sortiert und als Akzente `linkarzu_color01..08` verteilt; Headings sind abgedunkelte Akzente, Spell-Rot/Gelb fest.
6. Ergebnis `colorscheme/list/backdrop-sync.sh` (gitignored, generiert) → `zshrc/colorscheme-set.sh backdrop-sync.sh` verteilt auf kitty, ghostty, btop, starship, nvim, tmux usw.

Manuell erzwingen: `~/github/dotfiles-latest/scripts/backdrop-sync.sh --force`. Farbformeln ändern → `backdrop-sync.py`, nicht die generierte Datei. Pausieren: `launchctl unload ~/Library/LaunchAgents/com.morothox.backdropsync.plist`.

## Homebrew

Pakete dokumentiert in `brew/00-base`, `10-essential`, `15-nice-to-haves`, `20-optional`. Neu installierte Pakete dort in die passende Stufe eintragen. Third-Party-Taps erfordern `brew trust --cask <tap>/<cask>` (nur den einzelnen Cask vertrauen, nicht den ganzen Tap).

## Verifizieren / Neu laden

- nvim: `nvim --headless -c 'lua print(vim.inspect(<ausdruck>))' -c 'qa!'` für Config-Werte; Fehler beim Start: `nvim --headless -c 'qa!'` und stderr prüfen. Laufende Instanz: `:Lazy reload <plugin>` oder nvim neu starten (Nutzer sagen).
- zsh: `zsh -n <datei>` (Syntax), dann `source ~/.zshrc` in neuer Shell.
- tmux: `tmux source-file ~/.tmux.conf`.
- kitty/ghostty: Config-Reload (ghostty: `ghostty/reload-config.scpt`).
- yabai/skhd: `yabai --restart-service`, `skhd --restart-service`.
- sketchybar: `sketchybar --reload`.
- herdr: `herdr config check`, dann `herdr server reload-config` (oder prefix+r, Prefix ist `ctrl+s` wie tmux). Keys bewusst an `tmux.conf.sh` angelehnt. UI/Theme bewusst herdr-Standard lassen (Nutzer will das Original-Design, keine `[theme]`/`[ui]`-Overrides, kein Backdrop-Sync). Plugins: `herdr/install-plugins.sh` (Liste dort pflegen), Code in `~/.config/herdr/plugins/github/`. nvim-Gegenstück: `lua/plugins/herdr-splits.lua`.

## Andere Tools auf dem System

- voxtype (Diktieren): Config `~/Library/Application Support/voxtype/config.toml`, nicht im Repo. Modell `large-v3-turbo`, Sprache `de`, Hotkey `fn` im Toggle-Modus, Limit 300 s. Neustart: `pkill -f voxtype-bin; open -a /Applications/Voxtype.app`.
