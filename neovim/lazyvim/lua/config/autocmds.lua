-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Automatisches Spellchecking und Zeilenumbruch für Schulnotizen (Org, Typst, LaTeX, Text)
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("school_note_taking", { clear = true }),
  pattern = { "org", "typst", "tex", "text" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
  desc = "Enable spell checking and soft wrap for school notes",
})

-- Falls bereits eine Notizdatei beim Start geöffnet war
if vim.tbl_contains({ "org", "typst", "tex", "text" }, vim.bo.filetype) then
  vim.opt_local.wrap = true
  vim.opt_local.spell = true
end
