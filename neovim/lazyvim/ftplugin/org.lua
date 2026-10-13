-- Buffer-spezifische Einstellungen für Orgmode (Schulnotizen & Hausaufgaben)

-- 1. Rechtschreibung (Deutsch & Englisch) und Word-Wrap sofort aktivieren
vim.opt_local.spell = true
vim.opt_local.spelllang = { "de", "en" }
vim.opt_local.wrap = true

-- 2. Word-Style Unterstreichung: rote Welle für Rechtschreibfehler
vim.api.nvim_set_hl(0, "SpellBad", { undercurl = true, sp = "#ff5555" })
vim.api.nvim_set_hl(0, "SpellCap", { undercurl = true, sp = "#f1fa8c" })
vim.api.nvim_set_hl(0, "SpellRare", { undercurl = true, sp = "#bd93f9" })
vim.api.nvim_set_hl(0, "SpellLocal", { undercurl = true, sp = "#8be9fd" })

-- 3. Tastenkürzel für Rechtschreibung wie in Word

-- In Insert Mode: <C-s> korrigiert sofort den letzten Rechtschreibfehler und tippt weiter!
vim.keymap.set("i", "<C-s>", "<c-g>u<Esc>[s1z=`]a<c-g>u", {
  buffer = true,
  desc = "Vorherigen Tippfehler automatisch korrigieren",
})

-- In Normal Mode: <leader>z öffnet die Wortvorschläge im modernen Picker
vim.keymap.set("n", "<leader>z", function()
  if package.loaded["snacks"] and Snacks and Snacks.picker then
    Snacks.picker.spelling()
  else
    vim.cmd("normal! z=")
  end
end, { buffer = true, desc = "Rechtschreibkorrektur (Word-Style)" })

-- z= ebenfalls mit dem modernen Snacks Picker verbinden
vim.keymap.set("n", "z=", function()
  if package.loaded["snacks"] and Snacks and Snacks.picker then
    Snacks.picker.spelling()
  else
    vim.cmd("normal! z=")
  end
end, { buffer = true, desc = "Rechtschreibvorschläge" })

-- 4. Häufige Schul-Autokorrekturen (wie in Word)
local abbrevs = {
  ["z.b."] = "z. B.",
  ["d.h."] = "d. h.",
  ["u.a."] = "u. a.",
  ["o.ä."] = "o. Ä.",
  ["m.e."] = "m. E.",
  ["v.a."] = "vor allem",
  ["teh"] = "the",
  ["seperat"] = "separat",
  ["wiederspiegeln"] = "widerspiegeln",
}
for lhs, rhs in pairs(abbrevs) do
  vim.cmd(string.format("iabbrev <buffer> %s %s", lhs, rhs))
end
