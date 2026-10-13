return {
  {
    "chipsenkbeil/org-roam.nvim",
    ft = { "org" },
    cmd = { "Roam", "OrgRoam" },
    dependencies = {
      "nvim-orgmode/orgmode",
    },
    opts = {
      directory = vim.fn.expand("~/orgfiles"),
      org_files = {
        vim.fn.expand("~/orgfiles/**/*"),
        vim.fn.expand("~/Project/life-vault/**/*"),
      },
      templates = {
        m = {
          description = "Mathe Konzept",
          target = "faecher/mathe/%<%Y%m%d%H%M%S>-%[slug].org",
          template = "#+filetags: :mathe:q12:\n\n* Zusammenfassung\n  %?\n\n* Kernbegriffe & Formeln\n  - \n\n* Verwandte Themen / Links\n  - ",
        },
        w = {
          description = "WR (Wirtschaft & Recht)",
          target = "faecher/wr/%<%Y%m%d%H%M%S>-%[slug].org",
          template = "#+filetags: :wr:lk:q12:\n\n* Zusammenfassung\n  %?\n\n* Prüfungsschema & Definitionen\n  - \n\n* Verwandte Themen / Links\n  - ",
        },
        p = {
          description = "Physik Konzept",
          target = "faecher/physik/%<%Y%m%d%H%M%S>-%[slug].org",
          template = "#+filetags: :physik:q12:\n\n* Zusammenfassung\n  %?\n\n* Formeln & Gesetzmäßigkeiten\n  - \n\n* Versuche & Herleitungen\n  - ",
        },
        c = {
          description = "Chemie Konzept",
          target = "faecher/chemie/%<%Y%m%d%H%M%S>-%[slug].org",
          template = "#+filetags: :chemie:q12:\n\n* Zusammenfassung\n  %?\n\n* Reaktionsgleichungen & Mechanismen\n  - ",
        },
        d = {
          description = "Deutsch Analyse / Epoche",
          target = "faecher/deutsch/%<%Y%m%d%H%M%S>-%[slug].org",
          template = "#+filetags: :deutsch:q12:\n\n* Analyse & Kernaussagen\n  %?\n\n* Epochenmerkmale & Zitate\n  - ",
        },
        e = {
          description = "Englisch Topic",
          target = "faecher/englisch/%<%Y%m%d%H%M%S>-%[slug].org",
          template = "#+filetags: :englisch:q12:\n\n* Summary & Key Arguments\n  %?\n\n* Vocabulary & Phrases\n  - ",
        },
        g = {
          description = "Geschichte Ereignis / Epoche",
          target = "faecher/geschichte/%<%Y%m%d%H%M%S>-%[slug].org",
          template = "#+filetags: :geschichte:q12:\n\n* Historischer Kontext & Verlauf\n  %?\n\n* Ursachen & Folgen\n  - ",
        },
        u = {
          description = "PuG (Politik und Gesellschaft)",
          target = "faecher/pug/%<%Y%m%d%H%M%S>-%[slug].org",
          template = "#+filetags: :pug:q12:\n\n* Institutionen & Konfliktfeld\n  %?\n\n* Argumente & Positionen\n  - ",
        },
        r = {
          description = "Religion Thema",
          target = "faecher/religion/%<%Y%m%d%H%M%S>-%[slug].org",
          template = "#+filetags: :religion:q12:\n\n* Theologische & ethische Fragen\n  %?\n\n* Positionen & Bibelstellen\n  - ",
        },
        k = {
          description = "Kunst Epoche / Werk",
          target = "faecher/kunst/%<%Y%m%d%H%M%S>-%[slug].org",
          template = "#+filetags: :kunst:q12:\n\n* Werkbetrachtung & Merkmale\n  %?",
        },
        v = {
          description = "vkM (Vertiefungskurs Mathe)",
          target = "faecher/vkm/%<%Y%m%d%H%M%S>-%[slug].org",
          template = "#+filetags: :vkm:q12:\n\n* Vertiefungsthema\n  %?",
        },
        s = {
          description = "Sport Theorie",
          target = "faecher/sport/%<%Y%m%d%H%M%S>-%[slug].org",
          template = "#+filetags: :sport:q12:\n\n* Bewegungslehre / Trainingslehre\n  %?",
        },
        z = {
          description = "Standard Zettel (Allgemein)",
          target = "faecher/allgemein/%<%Y%m%d%H%M%S>-%[slug].org",
          template = "#+filetags: :schule:allgemein:\n\n* %?",
        },
        -- 🏃 LIFE VAULT ROAM TEMPLATES (Großbuchstaben für klare Trennung von Schule)
        L = {
          description = "🏃 Life Vault: Zettel / Konzept",
          target = "../Project/life-vault/knowledge/%<%Y%m%d%H%M%S>-%[slug].org",
          template = "#+title: ${title}\n#+filetags: :life:concept:\n\n* %?",
        },
        T = {
          description = "🏃 Life Vault: Trainings-Log",
          target = "../Project/life-vault/logs/%<%Y>/training/%<%Y-%m-%d>_%[slug].org",
          template = "#+title: %^{Titel}\n#+filetags: :log:training:\n\n* Telemetrie\n- Distanz: %^{Distanz}\n- Dauer: %^{Dauer}\n- Avg HR: %^{Avg HR} bpm\n- Max HR: %^{Max HR} bpm\n\n* Verlauf & Notizen\n%?",
        },
        P = {
          description = "🏃 Life Vault: Projekt-Plan",
          target = "../Project/life-vault/projects/%<%Y%m%d%H%M%S>-%[slug].org",
          template = "#+title: ${title}\n#+filetags: :life:project:\n\n* 🎯 Ziel & Meilensteine\n- [ ] %?\n\n* Kontext & Ressourcen\n",
        },
        R = {
          description = "🏃 Life Vault: Reflexion / Coaching-Log",
          target = "../Project/life-vault/logs/%<%Y>/coaching/%<%Y-%m-%d>_%[slug].org",
          template = "#+title: %^{Titel}\n#+filetags: :log:coaching:\n\n* 💭 Situation & Reflexion\n%?\n\n* 🛠️ Nächster Schritt\n- [ ] ",
        },
      },
      extensions = {
        dailies = {
          directory = "daily",
          templates = {
            d = {
              description = "Schultag Tagesnotiz",
              target = "%<%Y-%m-%d>.org",
              template = "#+title: %<%Y-%m-%d %A>\n#+filetags: :daily:\n\n* Stundenplan & Unterricht\n  - [ ] %?\n\n* Heutige Hausaufgaben & Erledigungen\n  - [ ] \n\n* Wichtige Notizen & Erkenntnisse\n  ",
            },
          },
        },
      },
      bindings = {
        prefix = "<Leader>n",
      },
    },
    config = function(_, opts)
      local roam = require("org-roam")
      roam.setup(opts)

      -- Direkte, unmissverständliche Keymaps für Org-Buffer & Global
      local function map_roam(mode, lhs, fn, desc)
        vim.keymap.set(mode, lhs, fn, { desc = desc, silent = true })
      end

      -- Suche & Capture (global verfügbar)
      map_roam("n", "<leader>nf", function() roam.api.find_node() end, "Org-Roam: Notiz suchen (Find Node)")
      map_roam("n", "<leader>nc", function() roam.api.capture_node() end, "Org-Roam: Neue Notiz (Capture Node)")

      -- Verlinken & Erstellen direkt an der Cursorstelle (Normal & Visual)
      map_roam({ "n", "v" }, "<leader>ni", function() roam.api.insert_node() end, "Org-Roam: Link/Node einfügen")
      map_roam({ "n", "v" }, "<leader>nm", function() roam.api.insert_node({ immediate = true }) end, "Org-Roam: Link sofort einfügen")

      -- Backlinks Panel & Aliase
      map_roam("n", "<leader>nl", function() roam.ui.toggle_node_buffer() end, "Org-Roam: Backlinks Panel")
      map_roam("n", "<leader>naa", function() roam.api.add_alias() end, "Org-Roam: Alias hinzufügen")
      map_roam("n", "<leader>nar", function() roam.api.remove_alias() end, "Org-Roam: Alias entfernen")

      -- Dailies
      map_roam("n", "<leader>ndn", function() roam.ext.dailies.goto_today() end, "Org-Roam: Heute öffnen")
      map_roam("n", "<leader>ndy", function() roam.ext.dailies.goto_yesterday() end, "Org-Roam: Gestern öffnen")
      map_roam("n", "<leader>ndt", function() roam.ext.dailies.goto_tomorrow() end, "Org-Roam: Morgen öffnen")
      map_roam("n", "<leader>ndd", function() roam.ext.dailies.goto_date() end, "Org-Roam: Datum öffnen")
      map_roam("n", "<leader>ndN", function() roam.ext.dailies.capture_today() end, "Org-Roam: In Heute erfassen")

      -- Graph View (Interaktiver 2D Force-Graph)
      local function open_org_graph()
        local script = vim.fn.expand("~/Project/life-vault/scripts/graph_view.py")
        if vim.fn.filereadable(script) == 1 then
          vim.notify("Generiere Org-Roam Graph...", vim.log.levels.INFO, { title = "Org-Roam Graph" })
          vim.fn.jobstart({ "python3", script, "--open" }, {
            detach = true,
            on_exit = function(_, code)
              if code == 0 then
                vim.notify("Graph erfolgreich geöffnet!", vim.log.levels.INFO, { title = "Org-Roam Graph" })
              else
                vim.notify("Fehler beim Öffnen des Graphs.", vim.log.levels.ERROR, { title = "Org-Roam Graph" })
              end
            end,
          })
        else
          vim.notify("Graph-Script nicht gefunden unter: " .. script, vim.log.levels.ERROR)
        end
      end

      map_roam("n", "<leader>ng", open_org_graph, "Org-Roam: Graph View öffnen (Interaktiv)")
      vim.api.nvim_create_user_command("OrgRoamGraph", open_org_graph, { desc = "Interaktiven Org-Roam Graph öffnen" })
    end,
  },

  -- Which-Key Menübeschriftungen für schnelles Zurechtfinden
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        { "<leader>n", group = "org-roam / zettelkasten", icon = "󰠮 " },
        { "<leader>nf", desc = "Find Node (Notiz suchen)" },
        { "<leader>ni", desc = "Insert Node (Link zu Notiz)" },
        { "<leader>nm", desc = "Insert Node Immediate" },
        { "<leader>nc", desc = "Capture Roam Node" },
        { "<leader>nl", desc = "Toggle Backlinks Panel (wie Obsidian)" },
        { "<leader>ng", desc = "Graph View (Interaktiver 2D Force-Graph)" },
        { "<leader>na", group = "aliase" },
        { "<leader>naa", desc = "Add Alias" },
        { "<leader>nar", desc = "Remove Alias" },
        { "<leader>nd", group = "dailies (tagebuch / schultage)", icon = " " },
        { "<leader>ndn", desc = "Heute öffnen" },
        { "<leader>ndy", desc = "Gestern öffnen" },
        { "<leader>ndt", desc = "Morgen öffnen" },
        { "<leader>ndd", desc = "Datum auswählen" },
        { "<leader>ndN", desc = "In Heute erfassen" },
        { "<leader>ndY", desc = "In Gestern erfassen" },
        { "<leader>ndT", desc = "In Morgen erfassen" },
        { "<leader>ndD", desc = "In Datum erfassen" },
      },
    },
  },
}
