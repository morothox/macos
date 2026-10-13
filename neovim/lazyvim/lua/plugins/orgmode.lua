return {
  -- Schöne Unicode-Bullets für Überschriften und Checkboxen
  {
    "akinsho/org-bullets.nvim",
    ft = { "org" },
    opts = {
      symbols = {
        list = "•",
        headlines = { "◉", "○", "✸", "✿", "◆", "◇" },
        checkboxes = {
          half = { "", "@org.checkbox.halfchecked" },
          done = { "✓", "@org.keyword.done" },
          todo = { "˟", "@org.keyword.todo" },
        },
      },
    },
  },

  -- Emoji, Wörterbuch & Spell-Autocompletion Integration für blink.cmp
  {
    "saghen/blink.cmp",
    dependencies = {
      "moyiz/blink-emoji.nvim",
      "ribru17/blink-cmp-spell",
      "Kaiser-Yang/blink-cmp-dictionary",
    },
    opts = function(_, opts)
      opts.sources = opts.sources or {}
      opts.sources.per_filetype = opts.sources.per_filetype or {}
      opts.sources.per_filetype.org = {
        "orgmode",
        "spell",
        "dictionary",
        "buffer",
        "snippets",
        "emoji",
        "path",
      }

      opts.sources.providers = opts.sources.providers or {}

      opts.sources.providers.orgmode = {
        name = "Orgmode",
        module = "orgmode.org.autocompletion.blink",
        fallbacks = { "buffer" },
      }

      opts.sources.providers.emoji = {
        module = "blink-emoji",
        name = "Emoji",
        score_offset = 15,
        opts = { insert = true },
      }

      -- Rechtschreib-Vorschläge nur auf Abruf (<C-Space>): deutsches spellsuggest()
      -- blockiert synchron 1,5–4 s pro Wort (Komposita) und ließ nvim beim Tippen hängen.
      -- Markierung (rote Welle) und Wörterbuch-Autocomplete bleiben automatisch.
      opts.sources.providers.spell = {
        name = "Spell",
        module = "blink-cmp-spell",
        score_offset = 100,
        opts = {
          max_entries = 5,
          preselect_current_word = false,
          keep_all_entries = false,
          enable_in_context = function(ctx)
            return ctx.trigger.initial_kind == "manual"
          end,
        },
      }

      -- Automatische Wort-Vorschläge aus deutschem & englischem Wörterbuch
      opts.sources.providers.dictionary = {
        module = "blink-cmp-dictionary",
        name = "Dict",
        min_keyword_length = 3,
        score_offset = 20,
        opts = {
          dictionary_directories = {
            vim.fn.expand("~/github/dotfiles-latest/dictionaries"),
          },
        },
      }

      return opts
    end,
  },

  -- Umfangreiche Schul-Snippets für maximales Note-Taking
  {
    "L3MON4D3/LuaSnip",
    opts = function()
      local ls = require("luasnip")
      local s = ls.snippet
      local t = ls.text_node
      local i = ls.insert_node

      ls.add_snippets("org", {
        -- 1. Aufgaben & Termine
        s("todo", {
          t("* TODO "),
          i(1, "Aufgabe"),
          t({ "", "  DEADLINE: <" }),
          i(2, "YYYY-MM-DD"),
          t({ ">", "  " }),
          i(0),
        }),
        s("hw", {
          t("* TODO "),
          i(1, "Fach"),
          t(": "),
          i(2, "Hausaufgabe"),
          t({ "", "  DEADLINE: <" }),
          i(3, "YYYY-MM-DD"),
          t({ ">", "  Fach: " }),
          i(4, "Mathe"),
          t({ "", "  Notizen: " }),
          i(0),
        }),
        s("klausur", {
          t("* TODO Klausur in "),
          i(1, "Fach"),
          t({ "", "  DEADLINE: <" }),
          i(2, "YYYY-MM-DD"),
          t({ ">", "  Themen:", "  - " }),
          i(0),
        }),

        -- 2. Checkboxen & Listen
        s("cb", {
          t("- [ ] "),
          i(0, "Aufgabe"),
        }),
        s("cbl", {
          t("* "),
          i(1, "Thema"),
          t({ " [0/3]", "  - [ ] " }),
          i(2, "Schritt 1"),
          t({ "", "  - [ ] " }),
          i(3, "Schritt 2"),
          t({ "", "  - [ ] " }),
          i(0, "Schritt 3"),
        }),

        -- 3. Tabellen & Mini-Excel
        s("tbl", {
          t({ "| Spalte 1 | Spalte 2 | Spalte 3 |", "|---+---+---|", "| " }),
          i(1, "Wert 1"),
          t(" | "),
          i(2, "Wert 2"),
          t(" | "),
          i(0, "Wert 3"),
          t(" |"),
        }),
        s("calc", {
          t({
            "| Gegenstand | Menge | Einzelpreis | Gesamt |",
            "|------------+-------+-------------+--------|",
            "| Buch       | 2     | 15.00       |        |",
            "| Heft       | 5     | 2.50        |        |",
            "| Stifte     | 1     | 8.00        |        |",
            "|------------+-------+-------------+--------|",
            "| Summe      |       |             |        |",
            "#+TBLFM: $4=$2*$3;%.2f::@5$4=vsum(@2$4..@4$4);%.2f",
            "",
          }),
          i(0),
        }),

        -- 4. Code & Callout-Blöcke
        s("src", {
          t("#+BEGIN_SRC "),
          i(1, "python"),
          t({ "", "" }),
          i(0),
          t({ "", "#+END_SRC" }),
        }),
        s("quote", {
          t({ "#+BEGIN_QUOTE", "" }),
          i(0, "Zitat hier einfügen..."),
          t({ "", "#+END_QUOTE" }),
        }),
        s("tip", {
          t({ "#+BEGIN_QUOTE", "💡 *Tipp:* " }),
          i(0, "Wichtiger Hinweis..."),
          t({ "", "#+END_QUOTE" }),
        }),
        s("warn", {
          t({ "#+BEGIN_QUOTE", "⚠️ *Achtung / Klausurrelevant:* " }),
          i(0, "Häufige Fehlerquelle..."),
          t({ "", "#+END_QUOTE" }),
        }),
        s("info", {
          t({ "#+BEGIN_QUOTE", "ℹ️ *Definition:* " }),
          i(0, "Erklärung des Begriffs..."),
          t({ "", "#+END_QUOTE" }),
        }),

        -- 5. Naturwissenschaftliches Versuchsprotokoll (Physik / Chemie / Bio)
        s("exp", {
          t("* Versuch: "),
          i(1, "Titel des Experiments"),
          t({ "", "  Fach: " }),
          i(2, "Physik"),
          t({ "", "  Datum: " }),
          i(3, "YYYY-MM-DD"),
          t({ "", "", "  ** 1. Fragestellung & Ziel", "     " }),
          i(4, "Was soll untersucht werden?"),
          t({ "", "", "  ** 2. Versuchsaufbau & Materialien", "     - " }),
          i(5, "Materialien..."),
          t({ "", "", "  ** 3. Durchführung & Beobachtung", "     " }),
          i(6, "Ablauf des Versuchs..."),
          t({
            "",
            "",
            "  ** 4. Messwerte",
            "     | Messung | Variable X | Variable Y |",
            "     |---------+------------+------------|",
            "     | 1       |            |            |",
            "     | 2       |            |            |",
            "",
            "  ** 5. Auswertung & Deutung",
            "     ",
          }),
          i(0, "Erkenntnis / Formel / Fehlerbetrachtung"),
        }),

        -- 6. Text- & Gedichtanalyse (Deutsch / Sprachen)
        s("ana", {
          t("* Analyse: "),
          i(1, "Titel des Werks"),
          t(" von "),
          i(2, "Autor"),
          t({ "", "  Fach: " }),
          i(3, "Deutsch"),
          t({
            "",
            "",
            "  ** 1. Einleitung (TATTE)",
            "     - Textart: ",
          }),
          i(4, "Gedicht / Kurzgeschichte"),
          t({
            "",
            "     - Thema / Kernbotschaft: ",
          }),
          i(5, "Worum geht es?"),
          t({
            "",
            "",
            "  ** 2. Hauptteil",
            "     *** Inhaltlicher Aufbau & Sinnabschnitte",
            "         - ",
          }),
          i(6, "Strukturierung..."),
          t({
            "",
            "     *** Formale Gestaltung (Metrum, Reim, Kadenz)",
            "         - ",
          }),
          i(7, "Formanalyse..."),
          t({
            "",
            "     *** Rhetorische Mittel",
            "         | Vers / Zeile | Stilmittel | Textbeleg | Wirkung |",
            "         |--------------+------------+-----------+---------|",
            "         |              |            |           |         |",
            "",
            "  ** 3. Schluss & Gesamtdeutung",
            "     ",
          }),
          i(0, "Fazit & Absicht des Autors..."),
        }),

        -- 7. Vokabelliste / Glossar
        s("vok", {
          t({
            "| Vokabel / Begriff | Übersetzung / Definition | Beispielsatz |",
            "|-------------------+---------------------------+--------------|",
            "| ",
          }),
          i(1, "Wort"),
          t(" | "),
          i(2, "Bedeutung"),
          t(" | "),
          i(0, "Beispiel"),
          t(" |"),
        }),
      })
    end,
  },

  -- Which-Key Registrierung
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        { "<leader>o", group = "orgmode / schule & life", icon = " " },
        { "<leader>oa", "<cmd>OrgSuperAgenda<cr>", desc = "Org Super Agenda (Getrennt)" },
        { "<leader>oA", "<cmd>OrgSuperAgenda!<cr>", desc = "Org Super Agenda (Fullscreen)" },
        { "<leader>om", "<cmd>lua require('orgmode').action('agenda.prompt')<cr>", desc = "Agenda Menü (Schule / Life / Custom)" },
        { "<leader>oc", "<cmd>lua require('orgmode').action('capture.prompt')<cr>", desc = "Capture Menü (s=Schule, l=Life)" },
        { "<leader>og", "<cmd>OrgRoamGraph<cr>", desc = "Org-Roam Graph View (Interaktiv)" },
        { "<leader>oi", group = "insert (todo / deadline / schedule)" },
        { "<leader>ol", group = "links (insert / store)" },
        { "<leader>oo", "<cmd>lua vim.fn.jobstart({'open', '-a', 'Skim', vim.fn.expand('<cfile>')}, {detach = true})<cr>", desc = "Open Link/PDF in Skim" },
        { "<leader>op", desc = "Open PDF in Neovim Split (Image Buffer)" },
        { "<leader>ot", "<cmd>lua require('orgmode').action('org_mappings.todo_next_state')<cr>", desc = "Cycle TODO State" },
        { "<leader>os", group = "sniprun / code" },
        { "<leader>osr", "<cmd>SnipRun<cr>", desc = "Run Line / Snippet" },
        { "<leader>osi", "<cmd>SnipInfo<cr>", desc = "SnipRun Info" },
        { "<leader>osR", "<cmd>SnipReset<cr>", desc = "SnipRun Reset" },
        { "<leader>m", group = "math / latex", icon = "󰪚 " },
        { "<leader>mp", "<cmd>LatexPreview<cr>", desc = "LaTeX Bildvorschau toggeln" },
        { "<leader>mc", "<cmd>LatexClear<cr>", desc = "LaTeX Bilder entfernen" },
        { "<leader>ml", "<cmd>LatexPreview<cr>", desc = "LaTeX Bildvorschau toggeln" },
        { "<leader>mm", "<cmd>lua require('nabla').toggle_virt({ autowrap = true, silent = true })<cr>", desc = "Unicode Math Vorschau (Nabla)" },
      },
    },
  },

  -- Aesthetics: headlines.nvim für visuelle Hervorhebungen von Headings & Codeblöcken
  {
    "lukas-reineke/headlines.nvim",
    ft = { "org", "markdown" },
    dependencies = "nvim-treesitter/nvim-treesitter",
    opts = {
      org = {
        headline_highlights = { "Headline1", "Headline2", "Headline3", "Headline4", "Headline5", "Headline6" },
        codeblock_highlight = "CodeBlock",
        dash_highlight = "Dash",
        dash_string = "―",
        doubledash_highlight = "DoubleDash",
        doubledash_string = "═",
        quote_highlight = "Quote",
        quote_string = "┃",
        fat_headlines = true,
      },
    },
  },

  -- Aesthetics: org-modern.nvim für ein modernes Floating-Menü bei Agenda & Capture
  {
    "danilshvalov/org-modern.nvim",
    ft = { "org" },
  },

  -- Aesthetics & Productivity: org-super-agenda.nvim für gruppierte und farbige Agenda-Ansichten
  {
    "hamidi-dev/org-super-agenda.nvim",
    dependencies = {
      "nvim-orgmode/orgmode",
    },
    cmd = { "OrgSuperAgenda" },
    keys = {
      { "<leader>oa", "<cmd>OrgSuperAgenda<cr>", desc = "Org Super Agenda" },
      { "<leader>oA", "<cmd>OrgSuperAgenda!<cr>", desc = "Org Super Agenda Fullscreen" },
    },
    opts = {
      hide_empty_groups = true,
      groups = {
        {
          name = "🎓 Schule: Deadlines & Klausuren",
          matcher = function(i)
            local f = i.file or ""
            return f:find("orgfiles") and i.deadline and i.todo_state ~= "DONE"
          end,
          sort = { by = "deadline", order = "asc" },
        },
        {
          name = "📚 Schule: Hausaufgaben & Offene Aufgaben",
          matcher = function(i)
            local f = i.file or ""
            return f:find("orgfiles") and (i.todo_state == "TODO" or i.todo_state == "PROGRESS")
          end,
          sort = { by = "date_nearest", order = "asc" },
        },
        {
          name = "🏃 Life Vault: Meilensteine & Trainings-Events",
          matcher = function(i)
            local f = i.file or ""
            return f:find("life%-vault") and i.deadline and i.todo_state ~= "DONE"
          end,
          sort = { by = "deadline", order = "asc" },
        },
        {
          name = "🎯 Life Vault: Aktive Todos, Reha & Projekte",
          matcher = function(i)
            local f = i.file or ""
            return f:find("life%-vault") and (i.todo_state == "TODO" or i.todo_state == "PROGRESS")
          end,
          sort = { by = "priority", order = "asc" },
        },
        {
          name = "✅ Erledigt",
          matcher = function(i)
            return i.todo_state == "DONE"
          end,
        },
      },
    },
  },

  -- Productivity: Sniprun für interaktive Code-Ausführung direkt in Org-Babel-Blöcken
  {
    "michaelb/sniprun",
    branch = "master",
    build = "sh install.sh",
    cmd = { "SnipRun", "SnipInfo", "SnipReset" },
    keys = {
      { "<leader>osr", "<cmd>SnipRun<cr>", desc = "SnipRun Line" },
      { "<leader>osr", ":'<,'>SnipRun<cr>", mode = "v", desc = "SnipRun Selection" },
    },
    opts = {
      display = {
        "Classic",
        "VirtualTextOk",
      },
    },
  },

  -- Productivity: org-notebook.nvim (deaktiviert: kollidiert mit Treesitter bei temporären Org-Buffern)
  -- {
  --   "bitbloxhub/org-notebook.nvim",
  --   ft = { "org" },
  --   dependencies = {
  --     {
  --       "bitbloxhub/jupyter-api.nvim",
  --       build = 'RUSTFLAGS="-C link-arg=-undefined -C link-arg=dynamic_lookup" cargo build --release',
  --     },
  --   },
  --   opts = {},
  -- },

  -- Productivity: telescope-orgmode.nvim mit Snacks/Telescope Integration
  {
    "nvim-orgmode/telescope-orgmode.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-orgmode/orgmode",
      "folke/snacks.nvim",
    },
    config = function()
      local tom = require("telescope-orgmode")
      tom.setup({ adapter = "snacks" })

      vim.keymap.set("n", "<leader>ofh", tom.search_headings, { desc = "Search org headings" })
      vim.keymap.set("n", "<leader>oft", tom.search_tags, { desc = "Search org tags" })
      vim.keymap.set("n", "<leader>or", tom.refile_heading, { desc = "Org refile heading" })
      vim.keymap.set("n", "<leader>oli", tom.insert_link, { desc = "Org insert link" })
    end,
  },

  -- Productivity: org-link.nvim für erweitertes Verlinken & Navigieren in Org
  {
    "seflue/org-link.nvim",
    ft = { "org" },
    opts = {},
  },

  -- Productivity: org-cycle-lite.nvim für schnelles Doom-Emacs Subtree-Cycling
  {
    "aaratha/org-cycle-lite.nvim",
    ft = { "org" },
    opts = {
      keymap = "<Tab>",
    },
  },

  -- Haupt-Plugin: Orgmode
  {
    "nvim-orgmode/orgmode",
    event = "VeryLazy",
    ft = { "org" },
    dependencies = {
      "akinsho/org-bullets.nvim",
      "danilshvalov/org-modern.nvim",
    },
    config = function()
      local org = require("orgmode")
      local Menu = require("org-modern.menu")

      org.setup({
        -- Wo deine Schul- und Notizdateien liegen
        org_agenda_files = { "~/orgfiles/**/*", "~/orgfiles/*", "~/Project/life-vault/**/*", "~/Project/life-vault/*" },
        org_default_notes_file = "~/orgfiles/refile.org",
        -- Tags und Vererbung
        org_tags_column = -80,
        org_use_tag_inheritance = true,

        -- Status-Schlüsselwörter für Aufgaben
        org_todo_keywords = {
          "TODO(t)",
          "PROGRESS(p)",
          "WAITING(w)",
          "|",
          "DONE(d)",
          "CANCELLED(c)",
        },

        -- Farben für die verschiedenen Status
        org_todo_keyword_faces = {
          PROGRESS = ":foreground #fab387 :weight bold",
          WAITING = ":foreground #f9e2af :weight bold",
          CANCELLED = ":foreground #6c7086 :slant italic",
        },

        -- Vordefinierte Erfassungsvorlagen: Getrennt nach Schule (Q12) und Life Vault (<leader>oc)
        org_capture_templates = {
          -- 🎓 UNTERMENÜ SCHULE (Taste 's')
          s = "🎓 Schule (Q12)",
          sh = {
            description = "Hausaufgabe",
            template = "* TODO %?\n  DEADLINE: %t\n  Fach: %^{Fach|WR|Mathe|Physik|Chemie|Deutsch|Englisch|Geschichte|PuG|Religion|Kunst|vkM|Sport}\n  Notizen: ",
            target = "~/orgfiles/hausaufgaben.org",
          },
          sk = {
            description = "Klausur / Schulaufgabe",
            template = "* TODO Klausur in %^{Fach|WR|Mathe|Physik|Chemie|Deutsch|Englisch|Geschichte|PuG|Religion|Kunst|vkM}\n  DEADLINE: %^t\n  Themen:\n  - %?",
            target = "~/orgfiles/klausuren.org",
          },
          sm = {
            description = "Unterrichtsmitschrift",
            template = "* %^{Thema}\n  %U\n  Fach: %^{Fach|WR|Mathe|Physik|Chemie|Deutsch|Englisch|Geschichte|PuG|Religion|Kunst|vkM}\n\n  %?",
            target = "~/orgfiles/schule.org",
          },
          sp = {
            description = "Versuchsprotokoll (Physik/Chemie)",
            template = "* Versuch: %^{Titel}\n  Fach: %^{Fach|Physik|Chemie}\n  Datum: %U\n\n  ** 1. Fragestellung\n     %?\n\n  ** 2. Versuchsaufbau & Materialien\n     - \n\n  ** 3. Durchführung & Beobachtung\n     \n\n  ** 4. Messwerte\n     | Messung | Wert X | Wert Y |\n     |---------+--------+--------|\n     | 1       |        |        |\n\n  ** 5. Auswertung\n     ",
            target = "~/orgfiles/faecher/physik.org",
          },
          sv = {
            description = "Vokabel / Fachbegriff (Glossar)",
            template = "| %^{Begriff} | %^{Fach|WR|Mathe|Physik|Englisch|Deutsch} | %^{Bedeutung} | %? |",
            target = "~/orgfiles/vokabeln.org",
          },
          st = {
            description = "Schul-Todo (Allgemein)",
            template = "* TODO %?\n  DEADLINE: %t\n  %U",
            target = "~/orgfiles/refile.org",
          },

          -- 🏃 UNTERMENÜ LIFE VAULT (Taste 'l')
          l = "🏃 Life Vault (Athletik & Leben)",
          lt = {
            description = "Life-Todo / Meilenstein",
            template = "* TODO [#B] %?\n  DEADLINE: %t\n  :PROPERTIES:\n  :CREATED: %U\n  :END:\n  - Kontext: ",
            target = "~/Project/life-vault/agenda.org",
          },
          lw = {
            description = "Workout / Training Log",
            template = "* Training: %^{Sportart|Rennrad|Laufen|Schwimmen|Gym Oberkörper A|Gym Oberkörper B|Gym Unterkörper}\n  %U\n  :PROPERTIES:\n  :SPORT: %\\1\n  :DISTANZ: %^{Distanz (z. B. 50 km oder 8 km)}\n  :DAUER: %^{Dauer (z. B. 1:45 h)}\n  :AVG_HR: %^{Avg HR} bpm\n  :MAX_HR: %^{Max HR} bpm\n  :END:\n\n  ** Telemetrie & Auswertung\n  - Pace / Speed: %?\n  - Befinden / RPE (1-10): \n  - Besonderheiten: ",
            target = "~/Project/life-vault/logs/2026/training/%<%Y-%m-%d>_workout.org",
          },
          lr = {
            description = "Fuß-Reha / Physio Session",
            template = "* Reha-Session: %U\n  - [ ] Seated Calf Raises (Soleus): 4x20 Wdh.\n  - [ ] Tibialis Raises: 3x25 Wdh.\n  - [ ] Short Foot Exercise (Janda): 3x10 Wdh.\n  - [ ] Faszienball Fußsohle / Waden ausrollen\n  - Schmerzskala beim Gehen (0-10): %^{Schmerz (0-10)}\n  - Notizen: %?",
            target = "~/Project/life-vault/protocols/foot_rehab_protocol.org",
          },
          lc = {
            description = "Coaching / Reflexion / Prezedenzfall",
            template = "* Coaching-Notiz: %^{Thema}\n  %U\n  - Auslöser / Situation: %?\n  - Rationale Analyse (Code statt Selbsthass): \n  - Nächster konkreter Schritt: ",
            target = "~/Project/life-vault/coach.org",
          },
          ln = {
            description = "Schnelle Lebensnotiz (Life-Refile)",
            template = "* %?\n  %u",
            target = "~/Project/life-vault/agenda.org",
          },
        },

        -- Benutzerdefinierte, strikt getrennte Agenda-Ansichten (<leader>oa -> s / l / u)
        org_agenda_custom_commands = {
          s = {
            description = "🎓 Schule (Q12): Termine, Klausuren & Todos",
            types = {
              {
                type = "agenda",
                org_agenda_overriding_header = "🎓 Q12 SCHULE: Termine, Klausuren & Deadlines",
                org_agenda_files = { "~/orgfiles/**/*", "~/orgfiles/*" },
              },
              {
                type = "tags_todo",
                org_agenda_overriding_header = "📚 OFFENE HAUSAUFGABEN & SCHUL-TODOS",
                org_agenda_files = { "~/orgfiles/**/*", "~/orgfiles/*" },
              },
            },
          },
          l = {
            description = "🏃 Life Vault: Meilensteine, Athletik & Reha",
            types = {
              {
                type = "agenda",
                org_agenda_overriding_header = "🏃 LIFE VAULT: Meilensteine, Trainings-Events & Deadlines",
                org_agenda_files = { "~/Project/life-vault/**/*", "~/Project/life-vault/*" },
              },
              {
                type = "tags_todo",
                org_agenda_overriding_header = "🎯 AKTIVE LIFE-TODOS, REHA & PROJEKTE",
                org_agenda_files = { "~/Project/life-vault/**/*", "~/Project/life-vault/*" },
              },
            },
          },
          u = {
            description = "📋 Getrennte Gesamtübersicht (Schule & Life)",
            types = {
              {
                type = "tags_todo",
                org_agenda_overriding_header = "🎓 SCHULE (Q12)",
                org_agenda_files = { "~/orgfiles/**/*", "~/orgfiles/*" },
              },
              {
                type = "tags_todo",
                org_agenda_overriding_header = "🏃 LIFE VAULT (Athletik, Reha & Projekte)",
                org_agenda_files = { "~/Project/life-vault/**/*", "~/Project/life-vault/*" },
              },
            },
          },
        },

        -- UI & Window Verhalten
        win_split_mode = "horizontal",
        ui = {
          input = {
            use_vim_ui = false, -- Nutzt natives Neovim input statt fehleranfälliges Nui-Float
          },
          menu = {
            handler = function(data)
              -- org-modern stürzt bei fast_access/TODO-State-Wechsel ab oder blockiert den Rückgabewert.
              -- Nur für reguläre Menüs (Agenda, Capture etc.) nutzen:
              if data and data.kind ~= "todo_fast_access" and data.items and #data.items > 0 then
                return Menu:new({
                  window = {
                    margin = { 1, 0, 1, 0 },
                    padding = { 0, 1, 0, 1 },
                    title_pos = "center",
                    border = "rounded",
                    zindex = 1000,
                  },
                  icons = {
                    separator = "➜",
                  },
                }):open(data)
              end
              return require("orgmode.ui.menu")._default_menu(data)
            end,
          },
        },
      })

      -- Experimentelles LSP für Neovim 0.11+
      if vim.lsp and vim.lsp.enable then
        vim.lsp.enable("org")
      end
    end,
  },
}
