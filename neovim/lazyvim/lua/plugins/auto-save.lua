return {
  "okuuva/auto-save.nvim",
  cmd = "ASToggle",
  event = { "InsertLeave", "TextChanged" },
  opts = {
    enabled = true,
    trigger_events = {
      immediate_save = { "BufLeave", "FocusLost" },
      defer_save = { "InsertLeave", "TextChanged" },
      cancel_deferred_save = { "InsertEnter" },
    },
    debounce_delay = 135,
    condition = function(buf)
      -- Nicht in Org-Capture Fenstern oder temporären Buffern auto-speichern
      if vim.b[buf].org_capture or vim.b[buf].org_tmp_edit_window then
        return false
      end
      local ft = vim.bo[buf].filetype
      if ft == "" or ft == "noice" or ft == "notify" or ft == "lazy" then
        return false
      end
      return true
    end,
  },
}
