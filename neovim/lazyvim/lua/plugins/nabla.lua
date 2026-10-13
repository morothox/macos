return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "latex" })
      end
    end,
  },
  {
    "jbyuki/nabla.nvim",
    keys = {
      {
        "<leader>um",
        function()
          require("nabla").toggle_virt({ autowrap = true, silent = true })
        end,
        desc = "Toggle Math Preview (ASCII/Unicode)",
      },
      {
        "<leader>uM",
        function()
          require("nabla").popup()
        end,
        desc = "Popup Math Preview unter Cursor",
      },
      {
        "<leader>mm",
        function()
          require("nabla").toggle_virt({ autowrap = true, silent = true })
        end,
        desc = "Toggle Math Preview (ASCII/Unicode)",
      },
      {
        "<leader>mM",
        function()
          require("nabla").popup()
        end,
        desc = "Popup Math Preview unter Cursor",
      },
    },
  },
}
