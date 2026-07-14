-- Filename: ~/github/dotfiles-latest/neovim/lazyvim/lua/plugins/mason-nvim.lua

-- https://github.com/williamboman/mason.nvim
return {
  "mason-org/mason.nvim",
  opts = function(_, opts)
    vim.list_extend(opts.ensure_installed, {
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
