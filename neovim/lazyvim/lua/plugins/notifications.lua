return {
  -- Snacks.nvim: Benachrichtigungen von <leader>n auf <leader>z umleiten
  {
    "folke/snacks.nvim",
    keys = {
      -- Standard LazyVim <leader>n deaktivieren
      { "<leader>n", false },
      -- Notifications auf <leader>z legen
      {
        "<leader>z",
        function()
          if Snacks.config.picker and Snacks.config.picker.enabled then
            Snacks.picker.notifications()
          else
            Snacks.notifier.show_history()
          end
        end,
        desc = "Notification History",
      },
      {
        "<leader>uz",
        function()
          Snacks.notifier.hide()
        end,
        desc = "Dismiss All Notifications",
      },
    },
  },
}
