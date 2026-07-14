-- Enable AI completion integration
vim.g.ai_cmp = true

-- We're passing an env var from kitty, you can print it with:
-- :lua print(vim.env.NEOVIM_MODE)
-- Here we capture the environment variable to make it accessible to neovim
vim.g.neovim_mode = vim.env.NEOVIM_MODE or "default"
vim.g.scrollback_mode = vim.env.SCROLLBACK_MODE or "default"
vim.g.simpler_scrollback = vim.env.SIMPLER_SCROLLBACK or "default"

-- I have 2 style options "solid" and "transparent"
-- This style is defined in my zshrc file
-- :lua print(vim.env.MD_HEADING_BG)
vim.g.md_heading_bg = vim.env.MD_HEADING_BG or "transparent"

-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- Load custom highlights
require("config.highlights")

-- Delay for `skitty` configuration
if vim.g.neovim_mode == "skitty" then
  vim.wait(500, function()
    return false
  end) -- Wait for X miliseconds without doing anything
end
