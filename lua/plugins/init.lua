return {
  -- Colorschemes
  {
    "Mofiqul/vscode.nvim",
    custom = true,
    cond = not not vim.g.started_by_firenvim or "leetcode.nvim" == vim.fn.argv(0, -1)
  },
  -- { "folke/tokyonight.nvim", cond = not vim.g.started_by_firenvim and "leetcode.nvim" ~= vim.fn.argv(0, -1) },
  {
    "thesimonho/kanagawa-paper.nvim",
    custom = true,
    cond = not vim.g.started_by_firenvim and "leetcode.nvim" ~= vim.fn.argv(0, -1),
    opts = {
      dim_inactive = false,
      -- Ref: https://github.com/thesimonho/kanagawa-paper.nvim?tab=readme-ov-file#common-customizations
      overrides = function(colors)
        local theme = colors.theme
        return {
          NormalFloat = { bg = "NONE" },
          FloatBorder = { bg = "NONE" },
          FloatTitle = { bg = "NONE" },

          -- Save a hlgroup with dark background and dimmed foreground
          -- so that you can use it where you still want darker windows.
          -- E.g.: autocmd TermOpen * setlocal winhighlight=Normal:NormalDark
          NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },

          -- Popular plugins that open floats will link to NormalFloat by default;
          -- set their background accordingly if you wish to keep them dark and borderless
          -- LazyNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
          -- MasonNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },

          Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1 },  -- add `blend = vim.o.pumblend` to enable transparency
          PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
          PmenuSbar = { bg = theme.ui.bg_m1 },
          PmenuThumb = { bg = theme.ui.bg_p2 },

          StatusLine = { bg = theme.ui.bg_p1 },
          StatusLineNC = { bg = theme.ui.bg_p1 },
        }
      end,
      styles = {
        comment = { italic = false },
      },
    },
  },

  -- Others
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = (function()
        vim.api.nvim_create_autocmd("ColorScheme", {
          callback = function()
            -- For search
            local opts = { reverse = true }
            vim.api.nvim_set_hl(0, "Visual", opts)
            vim.api.nvim_set_hl(0, "Search", opts)
            vim.api.nvim_set_hl(0, "CurSearch", { link = "IncSearch" })
            vim.api.nvim_set_hl(0, "Substitute", { link = "IncSearch" })
            vim.api.nvim_set_hl(0, "YankyYanked", { link = "IncSearch" })

            -- For diff
            local opts1 = { underline = true }
            vim.api.nvim_set_hl(0, "DiffAdd", opts1)
            vim.api.nvim_set_hl(0, "DiffChange", opts1)
            vim.api.nvim_set_hl(0, "DiffDelete", opts)
            vim.api.nvim_set_hl(0, "DiffText", { link = "IncSearch" })

            -- For borders
            local opts2 = { fg = vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID("Conceal")), "fg", "gui") }
            vim.api.nvim_set_hl(0, "CursorLineNr", opts2)
            vim.api.nvim_set_hl(0, "LineNr", opts2)
            vim.api.nvim_set_hl(0, "LineNrAbove", opts2)
            vim.api.nvim_set_hl(0, "LineNrBelow", opts2)
            vim.api.nvim_set_hl(0, 'DiagnosticUnnecessary', opts2)
            vim.api.nvim_set_hl(0, 'WinSeparator', opts2)
          end
        })
        if not not vim.g.started_by_firenvim or "leetcode.nvim" == vim.fn.argv(0, -1) then
          return "vscode"
        end
        -- return "tokyonight"
        return "kanagawa-paper-ink"
      end)(),
      news = {
        lazyvim = false,
      },
      icons = {
        diagnostics = {
          Error = " ",
          Warn  = " ",
          Hint  = " ",
          Info  = " ",
        },
        git = {
          added = "+",
          modified = "~",
          removed = "-",
        }
      },
    },
  },
  { "folke/noice.nvim", enabled = false },
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "yioneko/nvim-yati",
      "yioneko/vim-tmindent",
    },
    opts = {
      -- highlight = { additional_vim_regex_highlighting = { "python" } },
      -- NOTE: The disabled languages will use the nvim-yati indent method.
      -- Also, add the language to `tm_fts` in the `default_fallback` function.
      -- Check here for all available languages by nvim-yati: https://github.com/yioneko/nvim-yati/tree/main/lua/nvim-yati/configs
      indent = { disable = { "python" } },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<cr>",
          node_incremental = "<cr>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
      yati = {
        enable = true,
        suppress_conflict_warning = true,
        -- Disable by languages, see `Supported languages`
        -- disable = { "python" },

        -- Whether to enable lazy mode (recommend to enable this if bad indent happens frequently)
        default_lazy = true,

        -- Determine the fallback method used when we cannot calculate indent by tree-sitter
        --   "auto": fallback to vim auto indent
        --   "asis": use current indent as-is
        --   "cindent": see `:h cindent()`
        -- Or a custom function return the final indent result.
        -- default_fallback = "auto"
        default_fallback = function(lnum, computed, bufnr)
          local tm_fts = { "python" } -- or any other langs
          if vim.tbl_contains(tm_fts, vim.bo[bufnr].filetype) then
            return require("tmindent").get_indent(lnum, bufnr) + computed
          end
          -- or any other fallback methods
          return require("nvim-yati.fallback").vim_auto(lnum, computed, bufnr)
        end,
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function()
      local parsers = require("nvim-treesitter.parsers").get_parser_configs()
      for _, p in pairs(parsers) do
        p.install_info.url = p.install_info.url:gsub("https://github.com/", "https://ghfast.top/https://github.com/")
      end
    end,
  },
  {
    "csexton/trailertrash.vim",
    custom = true,
    event = "VeryLazy",
    config = function()
      vim.cmd("hi link UnwantedTrailerTrash NONE")
      vim.api.nvim_create_autocmd("BufWritePre", {
        command = "TrailerTrim"
      })
    end
  },
  {
    "s1n7ax/nvim-window-picker",
    custom = true,
    keys = {
      {
        "<C-w><C-w>",
        function()
          local picked_window_id = require("window-picker").pick_window() or vim.api.nvim_get_current_win()
          vim.api.nvim_set_current_win(picked_window_id)
        end,
        mode = "n",
        silent = true,
        desc = "Pick a window"
      }
    },
    opts = {
      show_prompt = false,
      filter_rules = {
        bo = {
          filetype = { "notify" }
        }
      }
    },
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    dependencies = "s1n7ax/nvim-window-picker",
    keys = {
      -- Switch `<leader>e` and `<leader>E`, and add wincmd = for <leader>e.
      {
        "<leader>e",
        function()
          require("neo-tree.command").execute({ toggle = true, dir = vim.uv.cwd() })
          vim.cmd("wincmd =")
        end,
        desc = "Explorer NeoTree (cwd)",
      },
      { "<leader>E", "<leader>fe", desc = "Explorer NeoTree (Root Dir)", remap = true },
    },
    opts = {
      window = {
        width = "20%",
        mappings = {
          ["<C-s>"] = "split_with_window_picker",
          ["<C-v>"] = "vsplit_with_window_picker",
          ["<C-t>"] = "open_tab_drop",
          ["t"] = "open_tab_drop_and_close_tree",
          ["<C-h>"] = "close_all_subnodes",
          ["<C-c>"] = "revert_preview",
          ["I"] = "toggle_hidden"
        }
      },
      commands = {
        open_tab_drop_and_close_tree = function(state, toggle_directory)
          local node = state.tree:get_node()
          if node.type == "directory" or node.type == "message" or node.type == "terminal" then
            return
          end
          require("neo-tree.sources.common.commands").open_tab_drop(state, toggle_directory)
          local winid = state.winid
          if winid and vim.api.nvim_win_is_valid(winid) then
              vim.api.nvim_win_close(winid, true)
          end
        end,
      },
    },
  },
  {
    "folke/snacks.nvim",
    keys = {
      {
        "<leader>dr",
        function()
          local ft = vim.opt.filetype:get()
          local dir = vim.fn.expand("%:p:h")
          local fileName = vim.fn.expand("%:t")
          local fileNameWithoutExt = vim.fn.expand("%:t:r")
          local fileExt = vim.fn.expand("%:e")
          local cmd

          if ft == "pdf" then
            cmd = ("cd '%s' && pdftoppm -f 1 -l 1 -png '%s' > '/tmp/%s.png' && chafa '/tmp/%s.png'"):format(dir, fileName, fileNameWithoutExt, fileNameWithoutExt)
          elseif ft == "python" then
            cmd = ("cd '%s' && python '%s'"):format(dir, fileName)
          elseif ft == "sh" then
            cmd = ("cd '%s' && bash '%s'"):format(dir, fileName)
          elseif fileExt == "png" or fileExt == "jpg" or fileExt == "gif" or fileExt == "svg" then
            cmd = ("cd '%s' && chafa '%s'"):format(dir, fileName)
          end
          if not cmd then return end
          Snacks.terminal(cmd, { cwd = LazyVim.root(), interactive = false, win = { on_buf = function () vim.cmd.startinsert() end } })
        end,
        desc = "Debug run command for current filetype"
      },
      {
        "<leader>\\",
        function ()
          Snacks.terminal(vim.fn.input(""), { cwd = LazyVim.root(), interactive = true })
        end,
        desc = "Run custom command in snacks terminal."
      },
    },
    opts = {
      notifier = { enabled = false },
      dashboard = { enabled = false },
      words = {
        debounce = 0, -- time in ms to wait before updating
      },
      lazygit = {
        win = {
          style = "float",
          border = "single",
          height = 0.83,
          width = 0.83,
        },
      },
      terminal = {
        win = {
          style = "float",
          border = "single",
          height = 0.83,
          width = 0.83,
        },
      },
    }
  },
  {
    "glacambre/firenvim",
    custom = true,
    build = function() vim.fn["firenvim#install"](0) end,
    -- Lazy load firenvim
    -- Explanation: https://github.com/folke/lazy.nvim/discussions/463#discussioncomment-4819297
    cond = not not vim.g.started_by_firenvim,
    config = function()  -- NOTE: Must be in `config` instead of `opts`, otherwise firenvim will complain.
      vim.api.nvim_create_autocmd("UIEnter", {
        callback = function()
          local client = vim.api.nvim_get_chan_info(vim.v.event.chan).client
          if client and client.name == "Firenvim" then
            vim.opt.guifont = "FiraCode Nerd Font:h25"
            vim.opt.laststatus = 0
            vim.opt.swapfile = false
          end
        end
      })
      vim.api.nvim_create_autocmd("BufEnter", {
        pattern = { "github.com_*.txt", "gitee.com_*.txt" },
        callback = function()
          vim.opt.filetype = "markdown"
        end
      })
      vim.api.nvim_create_autocmd("BufEnter", {
        pattern = { "leetcode.com_*.txt", "leetcode.cn_*.txt" },
        callback = function()
          vim.opt.filetype = "python"
          vim.opt.expandtab = true
        end
      })
      vim.g.firenvim_config = {
        localSettings = {
          -- ["https?://[^/]+\\.zhihu\\.com/*"] = { priority = 1, takeover = "never" },
          -- ["https?://www\\.notion\\.so/*"] = { priority = 1, takeover = "never" },
          -- ["https?://leetcode\\.com.*playground.*shared"] = { priority = 1, takeover = "never" },
          -- ["https?://github1s\\.com/*"] = { priority = 1, takeover = "never" },
          -- ["https?://docs\\.qq\\.com/*"] = { priority = 1, takeover = "never" },
          -- [".*"] = { priority = 0 },
          -- ["https?://leetcode\\.cn/problems/*"] = { priority = 1, takeover = "always" },
          [".*"] = { priority = 0, takeover = "never" },
        }
      }
    end
  },
  {
    "folke/persistence.nvim",
    lazy = false,
    opts = function()
      -- Auto restore session
      vim.api.nvim_create_autocmd("VimEnter", {
        nested = true,
        callback = function()
          local persistence = require("persistence")
          if vim.fn.argc() == 0 and not vim.g.started_with_stdin then
            persistence.load()
          else
            persistence.stop()
          end
        end,
      })
    end
  },
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      current_line_blame_opts = {
        delay = 0,
      },
    }
  },
  {
    "akinsho/bufferline.nvim",
    opts = {
      options = {
        mode = "tabs",
        show_buffer_close_icons = false,
        show_close_icon = false,
      }
    }
  },
  { "folke/flash.nvim", enabled = false },
  {
    "kylechui/nvim-surround",
    custom = true,
    -- version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    opts = {
      -- Configuration here, or leave empty to use defaults
      keymaps = {
        insert = "<A-g>s",
        insert_line = "<A-g>S",
      }
    },
  },
  {
    "smoka7/hop.nvim",
    custom = true,
    -- version = "*",
    event = "VeryLazy",
    keys = {
      { "s", "<CMD>silent! HopChar1MW<CR>", mode = { "n", "o", "x" }, silent = true },
      -- { "<LEADER><LEADER>", "<CMD>silent! HopPatternMW<CR>", mode = { "n", "o", "x" }, silent = true }
    },
    opts = {}
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    opts = {
      scope = { enabled = false },
    },
  },
  {
    'kevinhwang91/nvim-hlslens',
    custom = true,
    keys = {
      { "/" },
      { "?" },
      { "n", function ()
        vim.cmd("normal! " .. vim.v.count1 .. "n")
        require("hlslens").start()
      end, mode = { "n", "v" }, silent = true },
      { "N", function ()
        vim.cmd("normal! " .. vim.v.count1 .. "N")
        require("hlslens").start()
      end, mode = { "n", "v" }, silent = true },
      { "*", [[*<CMD>lua require('hlslens').start()<CR>]], mode = { "n", "v" }, silent = true },
      { "#", [[#<CMD>lua require('hlslens').start()<CR>]], mode = { "n", "v" }, silent = true },
      { "g*", [[g*<CMD>lua require('hlslens').start()<CR>]], mode = { "n", "v" }, silent = true },
      { "g#", [[g#<CMD>lua require('hlslens').start()<CR>]], mode = { "n", "v" }, silent = true },
    },
    opts = {
      calm_down = true,
      nearest_float_when = "never",
    },
  },
  {
    "zbirenbaum/copilot.lua",
    opts = {
      suggestion = {
        keymap = {
          accept_line = "<C-l>",
        },
      }
    }
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    keys = {
      { "<C-9>", "<leader>aa", desc = "Toggle (CopilotChat)", mode = { "n", "v" }, remap = true },
    },
    build = "make tiktoken", -- Only on MacOS or Linux
    opts = {
      model = "Pro/deepseek-ai/DeepSeek-V3",
      window = {
        layout = "float",
        width = 0.8, -- fractional width of parent, or absolute width in columns when > 1
        height = 0.8, -- fractional height of parent, or absolute height in rows when > 1
      },
      mappings = {
        close = {
          normal = "<C-9>",
          insert = "<C-9>",
        },
        reset = {
          callback = function()
            require("CopilotChat").reset()
            vim.defer_fn(function()
              vim.cmd("startinsert")
            end, 100)
          end
        }
      },
      providers = {
        openai = {
          prepare_input = require("CopilotChat.config.providers").copilot.prepare_input,
          prepare_output = require("CopilotChat.config.providers").copilot.prepare_output,
          get_headers = function()
            return {
              ["Authorization"] = "Bearer " .. (_G.localhost.OPENAI_API_KEY or os.getenv("OPENAI_API_KEY")),
            }
          end,
          get_models = function(headers)
            local response, err = require("CopilotChat.utils").curl_get("https://api.siliconflow.cn/v1/models", {
              headers = headers,
              json_response = true,
            })
            if err then
              error(err)
            end
            return vim.tbl_map(function(model)
              return {
                id = model.id,
                name = model.id,
              }
            end, response.body.data)
          end,
          embed = function(inputs, headers)
            local response, err = require("CopilotChat.utils").curl_post("https://api.siliconflow.cn/v1/embeddings", {
              headers = headers,
              json_request = true,
              json_response = true,
              body = {
                input = inputs,
                model = "Pro/BAAI/bge-m3",
              },
            })
            if err then
              error(err)
            end
            return response.body.data
          end,
          get_url = function()
            return "https://api.siliconflow.cn/v1/chat/completions"
          end,
        },
      },
    },
  },
  {
    "kawre/leetcode.nvim",
    custom = true,
    lazy = "leetcode.nvim" ~= vim.fn.argv(0, -1),
    cmd = "Leet",
    build = ":TSUpdate html", -- if you have `nvim-treesitter` installed
    dependencies = {
      "ibhagwan/fzf-lua",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      -- TODO: Try to add image support but failed.
      -- {
      --   "3rd/image.nvim",
      --   opts = {
      --    backend = "ueberzug" -- brew install jstkdng/programs/ueberzugpp
      --   }
      -- }
    },
    opts = {
      -- configuration goes here
      lang = "python3",
      cn = { -- leetcode.cn
          enabled = true,
          translator = false,
      },
      -- image_support = true,
      plugins = {
          non_standalone = true,
      },
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    cond = not vim.g.started_by_firenvim,
    opts = {
      options = {
        section_separators = { left = "", right = "" },
        component_separators = { left = "", right = "" }
      },
      sections = {
        lualine_z = {
          function()
            -- local date = vim.loop.os_uname().sysname == "Darwin" and "gdate" or "date"
            -- return " " .. vim.system({ date, "+%H:%M:%S.%3N" }, { text = true }):wait().stdout:gsub("\n", "")
            local now = os.date("*t")
            local seconds = os.clock()
            local milliseconds = math.floor((seconds - math.floor(seconds)) * 1000)
            return string.format(" %02d:%02d:%02d.%03d", now.hour, now.min, now.sec, milliseconds)
          end,
        }
      }
    }
  },
  {
    "ahmedkhalf/project.nvim",
    lazy = false,
    opts = {
      manual_mode = false,
      detection_methods = { "pattern" },
      patterns = { "._", ".git" },
    },
  },
  {
    "hedyhli/outline.nvim",
    opts = {
      outline_window = {
        width = 20,
        jump_highlight_duration = vim.highlight.priorities.user,
      },
      symbol_folding = {
        autofold_depth = vim.opt.foldlevel:get(),
      },
    },
  },
  -- {
  --   "ysl2/vim-python-pep8-indent",
  --   custom = true,
  --   ft = "python"
  -- },
  {
    "ibhagwan/fzf-lua",
    keys = {
      { "<leader><leader>", "<leader>fF", desc = "Find Files (cwd)", remap = true },
      { "<leader>/", "<leader>sG", desc = "Grep (cwd)", remap = true },
    },
    opts = function()
      local fzf_lua = require("fzf-lua")

      fzf_lua.config.defaults.keymap.fzf["ctrl-f"] = nil
      fzf_lua.config.defaults.keymap.fzf["ctrl-b"] = nil
      fzf_lua.config.defaults.keymap.builtin["<c-f>"] = nil
      fzf_lua.config.defaults.keymap.builtin["<c-b>"] = nil

      return {
        winopts = {
          border = "single",
          preview = {
            border = "single",
            hidden = true,
            vertical = "down:15,border-top",
            layout = "vertical",
          },
        },
        keymap = {
          builtin = {
            true,
            ["<C-r>"] = "toggle-preview",
            ["<C-u>"] = "preview-page-up",
            ["<C-d>"] = "preview-page-down",
          },
          fzf = {
            true,
            ["ctrl-r"] = "toggle-preview",
            ["ctrl-u"] = "preview-page-up",
            ["ctrl-d"] = "preview-page-down",
          },
        },
        actions = {
          files = {
            true,
            ["ctrl-t"] = fzf_lua.actions.file_tabedit,
          },
        },
        files = {
          actions = {
            ["alt-h"] = false,
            ["alt-i"] = false,
            ["ctrl-g"] = false,
            ["ctrl-y"] = fzf_lua.actions.toggle_hidden,
            ["ctrl-o"] = fzf_lua.actions.toggle_ignore
          },
        },
        grep = {
          actions = {
            ["alt-h"] = false,
            ["alt-i"] = false,
            ["ctrl-y"] = fzf_lua.actions.toggle_hidden,
            ["ctrl-o"] = fzf_lua.actions.toggle_ignore
          },
          winopts = {
            preview = {
              hidden = false,
            },
          },
        },
        lsp = {
          winopts = {
            preview = {
              hidden = false,
            },
          },
        },
        buffers = {
          winopts = {
            preview = {
              hidden = false,
            },
          },
        }
      }
    end
  },
  {
    "tpope/vim-rsi",
    custom = true,
    event = "InsertEnter"
  },
  {
    "gbprod/yanky.nvim",
    opts = {
      highlight = {
        on_put = false,
        timer = vim.highlight.priorities.user,
      },
      preserve_cursor_position = {
        enabled = false,
      },
    },
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    enabled = false,
    -- ft = { "markdown", "norg", "rmd", "org", "Avante" },
    ft = "Avante",
    opts = {
      -- enabled = false,
      -- file_types = { "markdown", "Avante" },
      file_types = { "Avante" },
    },
  },
  {
    "lervag/vimtex",
    opts = function()
      if not LazyVim.is_win() then
        vim.g.vimtex_view_method = "zathura"
      end
      vim.g.vimtex_quickfix_mode = 0
      vim.g.vimtex_view_zathura_use_synctex = 0
      -- Ref: https://github.com/lervag/vimtex/issues/2007
      vim.g.vimtex_indent_enabled = 0
    end
  },
  {
    "jiaoshijie/undotree",
    custom = true,
    dependencies = "nvim-lua/plenary.nvim",
    keys = {
      { "<leader>ut", function() require("undotree").toggle() end, desc = "Toggle undotree" },
    },
    opts = {
      float_diff = false,
      layout = "left_left_bottom",
      position = "right",
    },
    config = function(_, opts)
      local undotree = require("undotree")
      undotree.setup(opts)

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "undotreeDiff",
        callback = function()
          vim.keymap.set("n", "<C-w>q", function()
            undotree.toggle()
          end, { buffer = true, desc = "Toggle undotree for undotreeDiff filetype." })
        end
      })
    end
  },
  {
    "andis-sprinkis/lf-vim",
    custom = true,
    ft = "lf",
    config = function()
      -- Ref: https://github.com/andis-sprinkis/lf-vim/compare/master...sarmong:lf-vim:master
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "lf",
        callback = function()
          vim.opt_local.commentstring = "# %s"
        end
      })
    end
  },
  {
    "folke/trouble.nvim",
    opts = {
      focus = true,
    },
  },
  {
    "folke/trouble.nvim",
    opts = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "trouble",
        callback = function()
          vim.keymap.set("n", "<C-w>q", "q", { silent = true, buffer = true, remap = true })
        end
      })
    end
  },
  {
    "AndrewRadev/linediff.vim",
    custom = true,
    cmd = "Linediff"
  },
  {
    "kevinhwang91/nvim-fundo",
    custom = true,
    lazy = false,
    dependencies = "kevinhwang91/promise-async",
    build = function()
      require("fundo").install()
    end,
    config = function()  -- NOTE: This plugin is required to be configured specifically. The `config = true` will not work.
      require("fundo").setup({
        archives_dir = vim.fn.stdpath("state") .. "/fundo",
      })
    end
  },
  {
    -- support for image pasting
    "HakonHarnes/img-clip.nvim",
    custom = true,
    event = "VeryLazy",
    keys = {
      -- suggested keymap
      {
        "<leader>P",
        function()
          return (package.loaded["avante"] and vim.bo.filetype == "AvanteInput") and require("avante.clipboard").paste_image()
            or require("img-clip").paste_image()
        end,
        desc = "Paste image from system clipboard" },
    },
    opts = {
      -- recommended settings
      default = {
        dir_path = function()
          return "assets/" .. vim.fn.expand("%:t:r")
        end,
        relative_to_current_file = true,
        drag_and_drop = {
          insert_mode = true,
        },
        -- required for Windows users
        use_absolute_path = LazyVim.is_win(),
      },
    },
  },
  -- {
  --   "yetone/avante.nvim",
  --   custom = true,
  --   event = "VeryLazy",
  --   -- lazy = false,
  --   -- version = false, -- Set this to "*" to always pull the latest release version, or set it to false to update to the latest code changes.
  --   opts = {
  --     -- add any opts here
  --     -- for example
  --     provider = "openai",
  --     -- openai = {
  --     --   endpoint = "https://api.siliconflow.cn/v1",
  --     --   model = "Pro/deepseek-ai/DeepSeek-R1",
  --     --   disable_tools = true,
  --     -- },
  --     openai = {
  --       endpoint = "https://api.siliconflow.cn/v1",
  --       model = "Pro/deepseek-ai/DeepSeek-V3",
  --       disable_tools = true,
  --     },
  --     -- openai = {
  --     --   endpoint = "https://dashscope.aliyuncs.com/compatible-mode/v1",
  --     --   model = "qwen-max-latest",
  --     -- },
  --     windows = {
  --       sidebar_header = {
  --         rounded = false,
  --       },
  --       edit = {
  --         border = "single",
  --       },
  --       ask = {
  --         border = "single",
  --       },
  --     },
  --     file_selector = {
  --       provider = "fzf", -- Avoid native provider issues
  --       provider_opts = {},
  --     },
  --   },
  --   -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
  --   build = LazyVim.is_win() and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" or "http_proxy=127.0.0.1:7890 https_proxy=127.0.0.1:7890 make",
  --   dependencies = {
  --     -- "stevearc/dressing.nvim",
  --     "nvim-lua/plenary.nvim",
  --     "MunifTanjim/nui.nvim",
  --     -- The below dependencies are optional,
  --     -- "echasnovski/mini.pick", -- for file_selector provider mini.pick
  --     -- "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
  --     -- "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
  --     "ibhagwan/fzf-lua", -- for file_selector provider fzf
  --     "echasnovski/mini.icons", -- or echasnovski/mini.icons
  --     "zbirenbaum/copilot.lua", -- for providers='copilot'
  --     "HakonHarnes/img-clip.nvim",  -- support for image pasting
  --     -- "MeanderingProgrammer/render-markdown.nvim",  -- Make sure to set this up properly if you have lazy=true
  --     {
  --       "saghen/blink.cmp",
  --       opts = {
  --         sources = {
  --           default = { "avante_commands", "avante_mentions", "avante_files" },
  --           compat = {
  --             "avante_commands",
  --             "avante_mentions",
  --             "avante_files",
  --           },
  --           -- LSP score_offset is typically 60
  --           providers = {
  --             avante_commands = {
  --               name = "avante_commands",
  --               module = "blink.compat.source",
  --               score_offset = 90,
  --               opts = {},
  --             },
  --             avante_files = {
  --               name = "avante_files",
  --               module = "blink.compat.source",
  --               score_offset = 100,
  --               opts = {},
  --             },
  --             avante_mentions = {
  --               name = "avante_mentions",
  --               module = "blink.compat.source",
  --               score_offset = 1000,
  --               opts = {},
  --             },
  --           },
  --         },
  --       },
  --     },
  --     {
  --       "saghen/blink.compat",
  --       opts = function()
  --         -- monkeypatch cmp.ConfirmBehavior for Avante
  --         require("cmp").ConfirmBehavior = {
  --           Insert = "insert",
  --           Replace = "replace",
  --         }
  --       end,
  --     },
  --     {
  --       "folke/which-key.nvim",
  --       optional = true,
  --       opts = {
  --         spec = {
  --           { "<leader>a", group = "ai" },
  --         },
  --       },
  --     },
  --   },
  -- },
  {
    "dhruvasagar/vim-table-mode",
    custom = true,
    ft = "markdown",
    cmd = "TableModeToggle",
    keys = {
      { "<leader>tm", "<Plug>TableModeToggle", desc = "Toggle table mode" },
    },
  },
  {
    "hat0uma/csvview.nvim",
    custom = true,
    cmd = { "CsvViewEnable", "CsvViewDisable", "CsvViewToggle" },
    opts = {
      parser = { comments = { "#", "//" } },
      keymaps = {
        -- Text objects for selecting fields
        textobject_field_inner = { "if", mode = { "o", "x" } },
        textobject_field_outer = { "af", mode = { "o", "x" } },
        -- Excel-like navigation:
        -- Use <Tab> and <S-Tab> to move horizontally between fields.
        -- Use <Enter> and <S-Enter> to move vertically between rows and place the cursor at the end of the field.
        -- Note: In terminals, you may need to enable CSI-u mode to use <S-Tab> and <S-Enter>.
        jump_next_field_end = { "<Tab>", mode = { "n", "v" } },
        jump_prev_field_end = { "<S-Tab>", mode = { "n", "v" } },
        -- jump_next_row = { "<Enter>", mode = { "n", "v" } },
        -- jump_prev_row = { "<S-Enter>", mode = { "n", "v" } },
      },
    },
  },
}
