return {
  {
    "3rd/image.nvim",
    event = "VeryLazy",
    opts = {
      backend = "kitty", -- Für Kitty, Ghostty, WezTerm
      processor = "magick_cli",
      integrations = {
        markdown = {
          enabled = true,
          clear_in_insert_mode = false,
          download_remote_images = true,
          only_render_image_at_cursor = false,
          filetypes = { "markdown", "vimwiki" },
        },
        orgmode = {
          enabled = true,
          clear_in_insert_mode = false,
          download_remote_images = true,
          only_render_image_at_cursor = false,
          filetypes = { "org" },
        },
      },
      max_width = nil,
      max_height = nil,
      max_width_window_percentage = 90,
      max_height_window_percentage = 90,
      window_overlap_clear_enabled = false,
      window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
      tmux_show_only_in_active_window = true,
    },
    config = function(_, opts)
      local image = require("image")
      image.setup(opts)

      -- Funktion: PDF rendern und in vertikalem Split als Bild-Buffer anzeigen
      local function open_pdf_in_split(pdf_path, page)
        page = page or 0
        pdf_path = vim.fn.expand(pdf_path)

        if vim.fn.filereadable(pdf_path) == 0 then
          vim.notify("PDF Datei nicht gefunden: " .. pdf_path, vim.log.levels.ERROR)
          return
        end

        local tmp_dir = vim.fn.stdpath("cache") .. "/pdf_previews"
        vim.fn.mkdir(tmp_dir, "p")
        local safe_name = vim.fn.fnamemodify(pdf_path, ":t:r"):gsub("%s+", "_")
        local out_img = string.format("%s/%s_p%d.png", tmp_dir, safe_name, page)

        -- Mit ImageMagick + Ghostscript PDF-Seite in hochauflösendes PNG umwandeln
        local cmd = string.format("magick -density 200 '%s[%d]' '%s'", pdf_path, page, out_img)
        local res = vim.fn.system(cmd)

        if vim.v.shell_error ~= 0 or vim.fn.filereadable(out_img) == 0 then
          vim.notify("Fehler beim Rendern der PDF: " .. res, vim.log.levels.ERROR)
          return
        end

        -- Vertikalen Split öffnen mit Bilddatei als Buffer
        vim.cmd("vsplit " .. vim.fn.fnameescape(out_img))
        vim.bo.buftype = "nofile"
        vim.bo.bufhidden = "wipe"

        -- image.nvim manuell triggern für diese Datei
        vim.schedule(function()
          local img = image.from_file(out_img, {
            window = vim.api.nvim_get_current_win(),
            buffer = vim.api.nvim_get_current_buf(),
            x = 0,
            y = 0,
            width = math.floor(vim.api.nvim_win_get_width(0) * 0.95),
            height = math.floor(vim.api.nvim_win_get_height(0) * 0.95),
          })
          if img then
            img:render()
          end
        end)
      end

      -- PDF unter dem Cursor öffnen (aus Org-Links)
      local function open_pdf_under_cursor()
        local line = vim.api.nvim_get_current_line()
        local link = line:match("%[%[file:([^%]]+)%]%]")
          or line:match("%[%[([^%]]+%.pdf)%]")
          or line:match("%[%[([^%]]+)%]%[")
          or vim.fn.expand("<cfile>")

        if link and link:match("%.pdf$") then
          open_pdf_in_split(link, 0)
        else
          vim.ui.open(link or vim.fn.expand("<cfile>"))
        end
      end

      -- User Command & Keymap
      vim.api.nvim_create_user_command("PdfView", function(args)
        open_pdf_in_split(args.args, 0)
      end, { nargs = 1, complete = "file" })

      vim.keymap.set("n", "<leader>op", open_pdf_under_cursor, { desc = "PDF als Bild im Split-Buffer öffnen" })
    end,
  },
}
