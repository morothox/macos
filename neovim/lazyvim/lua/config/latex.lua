-- LaTeX-Fragmente in .org-Dateien direkt im Buffer als gerenderte Bilder anzeigen.
-- Pipeline: Fragment -> standalone.tex -> tectonic -> PDF -> magick -> PNG -> image.nvim
local M = {}

local cache_dir = vim.fn.stdpath("cache") .. "/latex_preview"
local tex_dir = cache_dir .. "/tex"
vim.fn.mkdir(tex_dir, "p")

-- Aktive Bilder und Status für sauberes Toggle/Clear
local active = {}
local active_buf = nil
local active_win = nil
local conceal_ns = vim.api.nvim_create_namespace("latex_preview_conceal")
local saved_win_opts = nil

--- Delimiter des Fragments entfernen bzw. normalisieren.
--- \begin{env}...\end{env} bleibt erhalten, damit align/matrix etc. klappen.
local function fragment_to_tex(fragment)
  local f = vim.trim(fragment)
  f = f:gsub("^%$%$", ""):gsub("%$%$$", "")
  f = f:gsub("^\\%[", ""):gsub("\\%]$", "")
  f = f:gsub("^\\%(", ""):gsub("\\%)$", "")
  f = f:gsub("^%$", ""):gsub("%$$", "")
  f = vim.trim(f)
  if f:match("^\\begin{") then
    return "\\[" .. f .. "\\]"
  end
  return "$\\displaystyle " .. f .. "$"
end

--- Alle LaTeX-Fragmente im Org-Buffer über Treesitter finden.
---@param bufnr integer
---@return { row: integer, col: integer, text: string }[]
function M.fragments(bufnr)
  bufnr = (bufnr == 0 or not bufnr) and vim.api.nvim_get_current_buf() or bufnr
  local ok, parser = pcall(vim.treesitter.get_parser, bufnr, "org")
  if not ok or not parser then
    return {}
  end

  local ok2, query = pcall(
    vim.treesitter.query.parse,
    "org",
    [[
      (inline_math_block) @math
      (display_math_block) @math
      (latex_env) @math
    ]]
  )
  if not ok2 or not query then
    return {}
  end

  local frags = {}
  local root = parser:parse()[1]:root()
  for _, node in query:iter_captures(root, bufnr) do
    local sr, sc, er, ec = node:range()
    table.insert(frags, {
      row = sr,
      col = sc,
      end_row = er,
      end_col = ec,
      text = vim.treesitter.get_node_text(node, bufnr),
    })
  end
  return frags
end

--- Fragmente kompilieren und als PNG cachen.
---@param fragments string[]
---@param opts? { density?: integer }
---@return table<integer, { path: string, w: integer, h: integer }>
function M.compile(fragments, opts)
  opts = opts or {}
  local density = opts.density or 300
  local fg_color = vim.o.background == "light" and "black" or "white"

  local preamble = table.concat({
    "\\documentclass[border=2pt,varwidth]{standalone}",
    "\\usepackage{amsmath,amssymb,amsfonts}",
    "\\usepackage{physics}",
    "\\usepackage{siunitx}",
    "\\usepackage{xcolor}",
    "\\usepackage{tikz}",
  }, "\n")

  local result = {}

  for i, fragment in ipairs(fragments) do
    local body = fragment_to_tex(fragment)
    local tex = table.concat({
      preamble,
      "\\begin{document}",
      "\\color{" .. fg_color .. "}",
      body,
      "\\end{document}",
    }, "\n")

    local id = vim.fn.sha256(tex):sub(1, 16)
    local png = ("%s/%s.png"):format(cache_dir, id)
    local dims = ("%s/%s.wxh"):format(cache_dir, id)

    if vim.fn.filereadable(png) == 0 or vim.fn.filereadable(dims) == 0 then
      local texfile = ("%s/%s.tex"):format(tex_dir, id)
      vim.fn.writefile(vim.split(tex, "\n"), texfile)

      local compile_cmd = { "tectonic", "-X", "compile", texfile, "--outdir", tex_dir }
      vim.fn.system(compile_cmd)
      local pdf = ("%s/%s.pdf"):format(tex_dir, id)

      if vim.v.shell_error ~= 0 or vim.fn.filereadable(pdf) == 0 then
        vim.notify("LaTeX-Kompilierfehler in Fragment " .. i, vim.log.levels.WARN)
        goto continue
      end

      local magick_cmd = {
        "magick",
        "-density",
        tostring(density),
        pdf,
        "-background",
        "none",
        "-trim",
        "+repage",
        png,
      }
      vim.fn.system(magick_cmd)

      if vim.v.shell_error ~= 0 or vim.fn.filereadable(png) == 0 then
        vim.notify("Magick-Konvertierungsfehler in Fragment " .. i, vim.log.levels.WARN)
        goto continue
      end

      local wh = vim.fn.system({ "magick", "identify", "-format", "%w %h", png })
      local w, h = wh:match("(%d+)%s+(%d+)")
      if not w then
        goto continue
      end
      vim.fn.writefile({ w .. " " .. h }, dims)
    end

    local wh_lines = vim.fn.readfile(dims)
    if wh_lines and wh_lines[1] then
      local w, h = wh_lines[1]:match("(%d+)%s+(%d+)")
      if w and h then
        result[i] = { path = png, w = tonumber(w), h = tonumber(h) }
      end
    end

    ::continue::
  end

  return result
end

--- Alle aktiven LaTeX-Bilder wieder entfernen
function M.clear()
  for _, img in ipairs(active) do
    pcall(function()
      img:clear()
    end)
  end
  active = {}

  if active_buf and vim.api.nvim_buf_is_valid(active_buf) then
    pcall(vim.api.nvim_buf_clear_namespace, active_buf, conceal_ns, 0, -1)
  end
  active_buf = nil

  if active_win and vim.api.nvim_win_is_valid(active_win) and saved_win_opts then
    pcall(function()
      vim.wo[active_win].conceallevel = saved_win_opts.conceallevel
      vim.wo[active_win].concealcursor = saved_win_opts.concealcursor
    end)
  end
  saved_win_opts = nil
  active_win = nil
end

--- Toggle: Alle LaTeX-Formeln im Buffer direkt als Bild einblenden/ausblenden
function M.preview()
  if #active > 0 then
    M.clear()
    vim.notify("LaTeX-Vorschau ausgeblendet", vim.log.levels.INFO)
    return
  end

  local ok, image = pcall(require, "image")
  if not ok then
    vim.notify("image.nvim ist nicht verfügbar", vim.log.levels.ERROR)
    return
  end

  local buf = vim.api.nvim_get_current_buf()
  local frags = M.fragments(buf)
  if #frags == 0 then
    vim.notify("Keine LaTeX-Formeln im Buffer gefunden", vim.log.levels.INFO)
    return
  end

  local win = vim.api.nvim_get_current_win()
  active_win = win
  active_buf = buf

  saved_win_opts = {
    conceallevel = vim.wo[win].conceallevel,
    concealcursor = vim.wo[win].concealcursor,
  }
  vim.wo[win].conceallevel = 2
  vim.wo[win].concealcursor = "nc"

  -- LaTeX-Quellcode mit Conceal ausblenden, damit keine Buchstaben durchscheinen
  for _, frag in ipairs(frags) do
    if frag.row == frag.end_row then
      pcall(vim.api.nvim_buf_set_extmark, buf, conceal_ns, frag.row, frag.col, {
        end_col = frag.end_col,
        conceal = "",
      })
    else
      for r = frag.row, frag.end_row do
        local line = vim.api.nvim_buf_get_lines(buf, r, r + 1, false)[1] or ""
        local sc = (r == frag.row) and frag.col or 0
        local ec = (r == frag.end_row) and frag.end_col or #line
        if ec > sc then
          pcall(vim.api.nvim_buf_set_extmark, buf, conceal_ns, r, sc, {
            end_col = ec,
            conceal = "",
          })
        end
      end
    end
  end

  local ok, image = pcall(require, "image")
  if not ok then
    vim.notify("image.nvim ist nicht verfügbar", vim.log.levels.ERROR)
    return
  end

  local buf = vim.api.nvim_get_current_buf()
  local frags = M.fragments(buf)
  if #frags == 0 then
    vim.notify("Keine LaTeX-Formeln im Buffer gefunden", vim.log.levels.INFO)
    return
  end

  local term_util = require("image.utils.term")
  local cell = term_util.get_size()
  local cell_w = (cell and cell.cell_width and cell.cell_width > 0) and cell.cell_width or 9
  local cell_h = (cell and cell.cell_height and cell.cell_height > 0) and cell.cell_height or 18

  vim.notify("Rendere " .. #frags .. " LaTeX-Formel(n)...", vim.log.levels.INFO)
  local compiled = M.compile(vim.tbl_map(function(f)
    return f.text
  end, frags))

  local win = vim.api.nvim_get_current_win()
  local win_width = vim.api.nvim_win_get_width(win)
  local max_cols = math.max(win_width - 6, 20)

  local rendered_count = 0
  for i, frag in ipairs(frags) do
    local info = compiled[i]
    if info then
      local width_cols = math.max(math.floor(info.w / cell_w + 0.5), 1)
      local height_rows = math.max(math.floor(info.h / cell_h + 0.5), 1)

      if width_cols > max_cols then
        height_rows = math.max(math.floor(height_rows * max_cols / width_cols + 0.5), 1)
        width_cols = max_cols
      end

      local img = image.from_file(info.path, {
        window = win,
        buffer = buf,
        x = frag.col,
        y = frag.row,
        width = width_cols,
        height = height_rows,
        with_virtual_padding = true,
      })

      if img then
        img:render()
        table.insert(active, img)
        rendered_count = rendered_count + 1
      end
    end
  end

  if rendered_count > 0 then
    vim.notify(rendered_count .. " Formel(n) gerendert", vim.log.levels.INFO)
  else
    vim.notify("Konnte keine Formeln rendern", vim.log.levels.WARN)
  end
end

function M.setup()
  vim.api.nvim_create_user_command("LatexPreview", M.preview, { desc = "LaTeX im Buffer rendern / toggeln" })
  vim.api.nvim_create_user_command("LatexClear", M.clear, { desc = "LaTeX gerenderte Bilder entfernen" })
  vim.keymap.set("n", "<leader>mp", M.preview, { desc = "LaTeX Bildvorschau toggeln" })
  vim.keymap.set("n", "<leader>mc", M.clear, { desc = "LaTeX Bilder entfernen" })
  vim.keymap.set("n", "<leader>ml", M.preview, { desc = "LaTeX Bildvorschau toggeln" })
end

return M
