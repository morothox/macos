-- Disable Harper LSP
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        harper_ls = false,
      },
    },
  },
}
