return {
  {
    "williamboman/mason.nvim",
    opts = {
      github = {
        download_url_template = "https://ghfast.top/https://github.com/%s/releases/download/%s/%s",
      },
      ensure_installed = { "latexindent", "cspell", "clang-format" },
    },
  },
  {
    "saghen/blink.cmp",
    -- NOTE: brew install rustup; rustup toolchain install nightly
    build = "cargo build --release",
    opts = {
      completion = {
        menu = { border = "single" },
        documentation = { window = { border = "single" } },
      },
      signature = {
        enabled = true,
        window = { border = "single" },
      },
    },
  },
  {
    "saghen/blink.cmp",
    opts = function(_, opts)
      -- From upstream: remove the "ai_accept" because I use `<C-g>` for ai completion.
      if not opts.keymap["<Tab>"] then
        if opts.keymap.preset == "super-tab" then -- super-tab
          opts.keymap["<Tab>"] = {
            require("blink.cmp.keymap.presets")["super-tab"]["<Tab>"][1],
            LazyVim.cmp.map({ "snippet_forward" }),
            "fallback",
          }
        else -- other presets
          opts.keymap["<Tab>"] = {
            LazyVim.cmp.map({ "snippet_forward" }),
            "fallback",
          }
        end
      end
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        gopls = {
          settings = {
            gopls = {
              analyses = {
                -- NOTE: LSP[gopls] Invalid settings: setting option "analyses": this setting is deprecated,
                -- use "the 'fieldalignment' analyzer was removed in gopls/v0.17.0;
                -- instead, hover over struct fields to see size/offset information (https://go.dev/issue/66861)" instead
                fieldalignment = false,
              },
            },
          },
        },
        -- basedpyright = {
        --   settings = {
        --     basedpyright = {
        --       analysis = {
        --         typeCheckingMode = "off",
        --         diagnosticSeverityOverrides = {
        --           reportUnusedImport = "none",
        --           reportUnusedVariable = "none",
        --         },
        --       },
        --     },
        --   },
        -- },
        jedi_language_server = {
          init_options = {
            completion = {
              disableSnippets = true,
            },
          },
        },
      },
      -- setup = {
      --   -- Ref: https://www.reddit.com/r/neovim/comments/108tjy0/nvimlspconfig_how_to_disable_hints_for_unused
      --   basedpyright = function()
      --     -- LazyVim.lsp.on_attach(function(client, _)
      --     --   local function pyright_filter(diagnostic)
      --     --     return not (
      --     --       diagnostic.message:find("Error") or
      --     --       diagnostic.message:find("Expected") or
      --     --       diagnostic.message:find("Statements must be separated by newlines or semicolons")
      --     --     )
      --     --   end
      --     --   vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
      --     --     function(_, params, client_id, _, config)
      --     --       params.diagnostics = vim.tbl_filter(pyright_filter, params.diagnostics)
      --     --       vim.lsp.diagnostic.on_publish_diagnostics(_, params, client_id, _, config)
      --     --     end,
      --     --     {}
      --     --   )
      --     -- end, "basedpyright")
      --     LazyVim.lsp.on_attach(function() vim.lsp.handlers["textDocument/publishDiagnostics"] = nil end, "basedpyright")
      --   end,
      -- },
      diagnostics = {
        virtual_text = false,
        float = {
          border = "single",
        },
        update_in_insert = true,
      },
      inlay_hints = { enabled = false },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = function()
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(ev)
          vim.api.nvim_create_autocmd("CursorHold", {
            buffer = ev.buf,
            callback = function()
              vim.diagnostic.open_float(nil, {
                focusable = false,
                close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
                source = "always",
                prefix = " ",
                scope = "cursor",
              })
            end,
          })
        end,
      })
    end,
  },
  -- {
  --   "tzachar/cmp-tabnine",
  --   lazy = true,
  -- },
  {
    "hrsh7th/nvim-cmp",
    cond = vim.g.lazyvim_cmp == "nvim-cmp",
    url = "git@github.com:iguanacucumber/magazine.nvim.git",
    opts = function()
      local cmp = require("cmp")
      return {
        window = {
          completion = cmp.config.window.bordered({ border = "single" }),
          documentation = cmp.config.window.bordered({ border = "single" }),
        },
        mapping = cmp.mapping.preset.insert({
          ["<tab>"] = function(fallback)
            -- From upstream: remove the "ai_accept" because I use `<C-g>` for ai completion.
            return LazyVim.cmp.map({ "snippet_forward" }, fallback)()
          end,
        }),
      }
    end,
  },
  {
    "hrsh7th/cmp-nvim-lsp",
    cond = vim.g.lazyvim_cmp == "nvim-cmp",
    url = "git@github.com:iguanacucumber/mag-nvim-lsp.git",
  },
  {
    "hrsh7th/cmp-buffer",
    cond = vim.g.lazyvim_cmp == "nvim-cmp",
    url = "git@github.com:iguanacucumber/mag-buffer.git",
  },
  {
    "hrsh7th/cmp-path",
    cond = vim.g.lazyvim_cmp == "nvim-cmp",
    url = "https://codeberg.org/FelipeLema/cmp-async-path",
  },
  {
    "ray-x/lsp_signature.nvim",
    custom = true,
    cond = vim.g.lazyvim_cmp == "nvim-cmp",
    event = "InsertEnter",
    config = function() -- Ref: https://github.com/ray-x/lsp_signature.nvim/issues/341#issuecomment-2466260487
      require("lsp_signature").on_attach({
        bind = true,
        hint_enable = false,
        handler_opts = {
          border = "single",
        },
      })
    end,
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        tex = { "latexindent" },
        c = { "clang_format" },
        cpp = { "clang_format" },
      },
      formatters = {
        -- Ref: https://github.com/LazyVim/LazyVim/discussions/3734
        clang_format = {
          prepend_args = { "--style={BasedOnStyle: Google, IndentWidth: 4, AllowShortFunctionsOnASingleLine: Empty}" },
        },
      },
    },
  },
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters = {
        cspell = {
          args = {
            "lint",
            "--no-color",
            "--no-progress",
            "--no-summary",
            "--config=" .. vim.fn.stdpath("config") .. "/cspell.json",
          },
        },
      },
    },
  },
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      opts.linters_by_ft = opts.linters_by_ft or {}
      for _, ft in ipairs({ "tex", "markdown" }) do
        opts.linters_by_ft[ft] = opts.linters_by_ft[ft] or {}
        table.insert(opts.linters_by_ft[ft], "cspell")
      end
    end,
  },
}
