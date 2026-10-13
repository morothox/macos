return {
  {
    "HakonHarnes/img-clip.nvim",
    event = "VeryLazy",
    opts = {
      default = {
        -- Bilder werden standardmäßig relativ in ein "img"-Verzeichnis des Fächerordners gelegt
        dir_path = "img",
        file_name = "%Y-%m-%d-%H-%M-%S",
        use_absolute_path = false,
        relative_to_current_file = true,
        prompt_for_file_name = true,
        drag_and_drop = {
          insert_mode = true,
        },
      },
      filetypes = {
        org = {
          url_encode_path = false,
          template = "[[file:$FILE_PATH]]",
          download_images = true,
        },
        markdown = {
          url_encode_path = false,
          template = "![$CURSOR]($FILE_PATH)",
          download_images = true,
        },
      },
    },
    keys = {
      {
        "<leader>oi",
        group = "insert (todo / deadline / schedule / image)",
      },
      {
        "<leader>oip",
        "<cmd>PasteImage<cr>",
        desc = "Paste Screenshot from Clipboard (Org/Markdown)",
      },
      {
        "<leader>ip",
        "<cmd>PasteImage<cr>",
        desc = "Paste Image from Clipboard",
      },
    },
  },
}
