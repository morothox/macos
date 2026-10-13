-- Filename: ~/github/dotfiles-latest/neovim/lazyvim/lua/plugins/smear-cursor.lua
-- https://github.com/sphamba/smear-cursor.nvim

return {
  "sphamba/smear-cursor.nvim",
  cond = function()
    return not vim.g.neovide
  end,
  opts = {
    -- Elegant, smooth cursor transitions
    stiffness = 0.6,
    relaxation_factor = 0.75,
    -- Deaktiviere smear-cursor in Orgmode und temporären Fenstern, um Crash bei BufWipeout / confirm() zu verhindern
    filetypes_disabled = {
      "org",
      "orgagenda",
      "org_capture",
      "noice",
      "notify",
    },
  },
}
