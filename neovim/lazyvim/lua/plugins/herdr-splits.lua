-- Filename: ~/github/dotfiles-latest/neovim/lazyvim/lua/plugins/herdr-splits.lua
-- https://github.com/lmilojevicc/herdr-splits.nvim
-- Gegenstück zum herdr-Plugin "herdr-splits" (herdr/config.toml, ctrl+h/j/k/l):
-- C-hjkl wechselt nahtlos zwischen nvim-Splits und herdr-Panes, wie
-- vim-tmux-navigator beim tmux. Nur aktiv, wenn nvim in herdr läuft.
-- Resize-Keys (M-hjkl) bewusst nicht gemappt: M-j/M-k sind LazyVims Zeilen-Verschieben.

return {
  "lmilojevicc/herdr-splits.nvim",
  cond = vim.env.HERDR_ENV == "1",
  event = "VeryLazy",
  opts = {},
  keys = {
    { "<C-h>", function() require("herdr-splits").move_cursor_left() end, desc = "Navigate left (herdr)" },
    { "<C-j>", function() require("herdr-splits").move_cursor_down() end, desc = "Navigate down (herdr)" },
    { "<C-k>", function() require("herdr-splits").move_cursor_up() end, desc = "Navigate up (herdr)" },
    { "<C-l>", function() require("herdr-splits").move_cursor_right() end, desc = "Navigate right (herdr)" },
  },
}
