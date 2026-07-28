return {
  -- Treesitter parsers for C, C++, CMake, CUDA, Ninja, Doxygen, LLVM, Make
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, {
          "c",
          "cpp",
          "cuda",
          "cmake",
          "ninja",
          "doxygen",
          "llvm",
          "make",
        })
      end
    end,
  },

  -- Mason package manager integration for C++ LSPs, Debuggers, Linters, Formatters
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "clangd",
        "clang-format",
        "codelldb",
        "neocmakelsp",
        "gersemi",
        "cmakelint",
        "cpplint",
      })
    end,
  },

  -- Extended clangd features (inlay hints, AST, type hierarchy, memory usage, source/header toggle)
  {
    "p00f/clangd_extensions.nvim",
    lazy = true,
    opts = {
      inlay_hints = {
        inline = false,
      },
      ast = {
        role_icons = {
          type = "",
          declaration = "",
          expression = "",
          specifier = "",
          statement = "",
          ["template argument"] = "",
        },
        kind_icons = {
          Compound = "",
          Recovery = "",
          TranslationUnit = "",
          PackExpansion = "",
          TemplateTypeParm = "",
          TemplateTemplateParm = "",
          TemplateParamObject = "",
        },
      },
    },
  },

  -- Language Server Protocol (LSP) setup for C/C++ (clangd) and CMake (neocmake)
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        clangd = {
          keys = {
            { "<leader>ch", "<cmd>LspClangdSwitchSourceHeader<cr>", desc = "Switch Source/Header (C/C++)" },
            { "<leader>cA", "<cmd>ClangdAST<cr>", desc = "View Clangd AST" },
            { "<leader>cM", "<cmd>ClangdMemoryUsage<cr>", desc = "View Clangd Memory Usage" },
            { "<leader>cT", "<cmd>ClangdTypeHierarchy<cr>", desc = "View Clangd Type Hierarchy" },
            { "<leader>cs", "<cmd>ClangdSymbolInfo<cr>", desc = "View Clangd Symbol Info" },
          },
          root_markers = {
            "compile_commands.json",
            "compile_flags.txt",
            "CMakeLists.txt",
            ".clangd",
            ".clang-tidy",
            ".clang-format",
            "Makefile",
            "configure.ac",
            "meson.build",
            "build.ninja",
            ".git",
          },
          capabilities = {
            offsetEncoding = { "utf-16" },
          },
          cmd = {
            "clangd",
            "--background-index",
            "--clang-tidy",
            "--header-insertion=iwyu",
            "--completion-style=detailed",
            "--function-arg-placeholders",
            "--fallback-style=llvm",
            "--suggest-missing-includes",
          },
          init_options = {
            usePlaceholders = true,
            completeUnimported = true,
            clangdFileStatus = true,
          },
        },
        neocmake = {},
      },
    },
  },

  -- Code formatting (conform.nvim) for C, C++, CUDA, and CMake
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        c = { "clang-format" },
        cpp = { "clang-format" },
        cuda = { "clang-format" },
        cmake = { "gersemi" },
      },
    },
  },

  -- Code linting (nvim-lint) for C, C++, and CMake
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters_by_ft = {
        c = { "cpplint" },
        cpp = { "cpplint" },
        cmake = { "cmakelint" },
      },
    },
  },

  -- Full CMake build, target selection, and debugging integration
  {
    "Civitasv/cmake-tools.nvim",
    lazy = true,
    opts = {
      cmake_build_directory = "build",
      cmake_generate_options = { "-DCMAKE_EXPORT_COMPILE_COMMANDS=1" },
      cmake_dap_configuration = {
        name = "CMake Debug",
        type = "codelldb",
        request = "launch",
        stopOnEntry = false,
        runInTerminal = false,
      },
    },
  },

  -- Neogen Doxygen documentation generator
  {
    "danymat/neogen",
    cmd = "Neogen",
    keys = {
      {
        "<leader>cd",
        function()
          require("neogen").generate()
        end,
        desc = "Generate Doxygen / Docstring (Neogen)",
      },
    },
    opts = {
      snippet_engine = "luasnip",
      languages = {
        cpp = {
          template = {
            annotation_convention = "doxygen",
          },
        },
        c = {
          template = {
            annotation_convention = "doxygen",
          },
        },
      },
    },
  },

  -- Neotest integration for C++ testing (GoogleTest / CTest)
  {
    "nvim-neotest/neotest",
    optional = true,
    dependencies = {
      "alfaix/neotest-gtest",
      "orjangj/neotest-ctest",
    },
    opts = function(_, opts)
      opts.adapters = opts.adapters or {}
      table.insert(opts.adapters, require("neotest-gtest")({}))
      table.insert(opts.adapters, require("neotest-ctest")({}))
    end,
  },
}
