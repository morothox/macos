-- Filename: ~/github/dotfiles-latest/neovim/neobean/lua/plugins/mason-nvim.lua

-- https://github.com/williamboman/mason.nvim
-- https://github.com/jonschlinkert/markdown-toc
return {
  "mason-org/mason.nvim",
  opts = function(_, opts)
    vim.list_extend(opts.ensure_installed, {
      -- -- I installed "templ" and other LSPS, these requirements can be found in
      -- -- the TEMPL docs https://templ.guide/commands-and-tools/ide-support/#neovim--050
      -- -- The templ command must be in your system path for the LSP to be able to start
      -- -- vim.list_extend(opts.ensure_installed, { "templ", "html-lsp", "htmx-lsp", "tailwindcss-language-server" })
      -- "templ",
      -- "html-lsp",
      -- -- htmx-lsp is the culprit for a bug that haunted me for fucking days.
      -- -- only when in markdown files my blink completions would take like 5
      -- -- seconds to load. You have no idea what I had to go through to figure
      -- -- this out. It broke after some updates, not sure which one, if the LSP
      -- -- itself, blink or what
      -- -- "htmx-lsp",

      -- "tailwindcss-language-server",

      "harper-ls",
      "prettier",
      "markdown-oxide",

      -- Language Servers (LSPs)
      "gopls",
      "pyright",
      "vtsls",
      "yaml-language-server",
      "json-lsp",
      "dockerfile-language-server",
      "terraform-ls",
      "helm-ls",
      "tinymist",

      -- Linters & Formatters
      "hadolint",

      -- Debuggers (DAP)
      "delve",
      "codelldb",
    })
  end,
}
