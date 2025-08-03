-- Replaces schema URLs with a proxied version based on a set of predefined rules.
-- This implementation assumes that all rule prefixes are mutually exclusive
-- (i.e., no rule's prefix is a substring of another's).
--
-- @param schemas table<string, any> The input schema table, where keys are the URLs.
-- @return table<string, any> A new table with the URLs replaced.
local function proxy_schema_urls(schemas)
  -- Define all replacement rules here.
  -- The key is the old prefix to be replaced, and the value is the new prefix.
  -- This map structure is simple and direct because matching order is not a concern.
  local replacement_rules = {
    ["https://alec016.github.io/Custom-Machinery"] = "https://ghfast.top/https://raw.githubusercontent.com/alec016/Custom-Machinery/refs/heads/1.19.2",
    ["https://github.com"] = "https://ghfast.top/https://github.com",
    ["https://json.schemastore.org"] = "https://ghfast.top/https://raw.githubusercontent.com/SchemaStore/schemastore/refs/heads/master/src/schemas/json",
    ["https://raw.githubusercontent.com"] = "https://ghfast.top/https://raw.githubusercontent.com",
  }

  -- Create a new table to store the results, avoiding modification during iteration.
  local new_schemas = {}

  for original_url, schema in pairs(schemas) do
    local new_url = original_url -- Assume no replacement by default.

    -- Iterate through the replacement rules. Order does not matter.
    for old_prefix, new_prefix in pairs(replacement_rules) do
      -- Check if the URL starts with the prefix to be replaced.
      -- The 'true' flag enables plain string comparison, which is fast.
      if original_url:find(old_prefix, 1, true) == 1 then
        -- If a match is found, construct the new URL.
        new_url = new_prefix .. original_url:sub(#old_prefix + 1)
        -- Since rules are independent, we can stop searching for this URL.
        break
      end
    end

    -- Assign the schema to the final URL (either replaced or original).
    new_schemas[new_url] = schema
  end

  return new_schemas
end

return {
  {
    "mason-org/mason.nvim",
    opts = {
      github = {
        download_url_template = "https://ghfast.top/https://github.com/%s/releases/download/%s/%s",
      },
      ensure_installed = {
        "latexindent",
        "cspell",
        "clang-format",
        -- "ty",
        "dockerfile-language-server",
        "vim-language-server",
      },
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
      -- NOTE: Rewrite LazyVim's LSP servers here.
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
        -- ruff = {
        --   -- NOTE: Conflict with `ty`.
        --   enabled = false,
        -- },
        jsonls = {
          on_new_config = function(new_config)
            vim.list_extend(
              new_config.settings.json.schemas or {},
              proxy_schema_urls(require("schemastore").json.schemas())
            )
          end,
        },
        yamlls = {
          on_new_config = function(new_config)
            new_config.settings.yaml.schemas = vim.tbl_deep_extend(
              "force",
              new_config.settings.yaml.schemas or {},
              proxy_schema_urls(require("schemastore").yaml.schemas())
            )
          end,
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

      -- NOTE: Add custom LSP servers here.
      -- local servers = {
      --   ty = {
      --     init_options = {
      --       settings = {
      --         -- ty language server settings go here
      --       },
      --     },
      --   },
      -- }
      -- for server, server_opts in pairs(servers) do
      --   vim.lsp.config(server, server_opts)
      -- end
      -- vim.lsp.enable({ "ty" })
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
