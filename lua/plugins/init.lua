local function exec(cmd)
  local file = io.popen(cmd)
  if not file then
    return
  end
  local output = file:read("*a")
  file:close()
  return (output or ""):match("^%s*(.-)%s*$")
end

return {
  -- Colorschemes
  {
    "Mofiqul/vscode.nvim",
    custom = true,
    cond = not not vim.g.started_by_firenvim or "leetcode.nvim" == vim.fn.argv(0, -1),
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

          Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1 }, -- add `blend = vim.o.pumblend` to enable transparency
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
            vim.api.nvim_set_hl(0, "DiagnosticUnnecessary", opts2)
            vim.api.nvim_set_hl(0, "WinSeparator", opts2)
          end,
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
          Warn = " ",
          Hint = " ",
          Info = " ",
        },
        git = {
          added = "+",
          modified = "~",
          removed = "-",
        },
      },
    },
  },
  { "folke/noice.nvim", enabled = false },
  -- {
  --   "nvim-treesitter/nvim-treesitter",
  --   dependencies = {
  --     "yioneko/nvim-yati",
  --     "yioneko/vim-tmindent",
  --   },
  --   opts = {
  --     -- highlight = { additional_vim_regex_highlighting = { "python" } },
  --     -- NOTE: The disabled languages will use the nvim-yati indent method.
  --     -- Also, add the language to `tm_fts` in the `default_fallback` function.
  --     -- Check here for all available languages by nvim-yati: https://github.com/yioneko/nvim-yati/tree/main/lua/nvim-yati/configs
  --     indent = { disable = { "python" } },
  --     incremental_selection = {
  --       enable = true,
  --       keymaps = {
  --         init_selection = "<cr>",
  --         node_incremental = "<cr>",
  --         scope_incremental = false,
  --         node_decremental = "<bs>",
  --       },
  --     },
  --     yati = {
  --       enable = true,
  --       suppress_conflict_warning = true,
  --       -- Disable by languages, see `Supported languages`
  --       -- disable = { "python" },
  --
  --       -- Whether to enable lazy mode (recommend to enable this if bad indent happens frequently)
  --       default_lazy = true,
  --
  --       -- Determine the fallback method used when we cannot calculate indent by tree-sitter
  --       --   "auto": fallback to vim auto indent
  --       --   "asis": use current indent as-is
  --       --   "cindent": see `:h cindent()`
  --       -- Or a custom function return the final indent result.
  --       -- default_fallback = "auto"
  --       default_fallback = function(lnum, computed, bufnr)
  --         local tm_fts = { "python" } -- or any other langs
  --         if vim.tbl_contains(tm_fts, vim.bo[bufnr].filetype) then
  --           return require("tmindent").get_indent(lnum, bufnr) + computed
  --         end
  --         -- or any other fallback methods
  --         return require("nvim-yati.fallback").vim_auto(lnum, computed, bufnr)
  --       end,
  --     },
  --   },
  -- },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function()
      local parsers = require("nvim-treesitter.parsers")
      for _, p in pairs(parsers) do
        if type(p) == "table" and p.install_info and p.install_info.url then
          p.install_info.url = p.install_info.url:gsub("^https://github.com/", "https://ghfast.top/https://github.com/")
        end
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
        command = "TrailerTrim",
      })
    end,
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
        desc = "Pick a window",
      },
    },
    opts = {
      show_prompt = false,
      filter_rules = {
        bo = {
          filetype = { "notify" },
        },
      },
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
      {
        "<leader>E",
        function()
          require("neo-tree.command").execute({ toggle = true, dir = LazyVim.root() })
          vim.cmd("wincmd =")
        end,
        desc = "Explorer NeoTree (Root Dir)",
      },
    },
    opts = {
      -- close_if_last_window = true,
      log_level = "warn",
      sort_case_insensitive = true,
      default_component_configs = {
        symlink_target = {
          enabled = true,
        },
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
      window = {
        width = "20%",
        mappings = {
          ["s"] = "split_with_window_picker",
          ["S"] = "",
          ["v"] = "vsplit_with_window_picker",
          ["t"] = "open_tab_drop",
          ["T"] = "open_tab_drop_and_close_tree",
          ["<C-c>"] = "revert_preview",
          ["I"] = "toggle_hidden",
          ["H"] = "",
          ["z"] = "expand_all_nodes",
          ["Z"] = "close_all_nodes",
        },
      },
    },
  },
  {
    "folke/snacks.nvim",
    keys = {
      {
        "<leader>ba",
        function()
          Snacks.bufdelete.all()
        end,
        mode = "n",
        desc = "Delete All Buffers",
      },
      {
        "<C-\\>",
        function()
          local cmd = nil
          if LazyVim.is_win() then
            cmd = "pwsh"
          else
            local tmux = _G.localhost.MYTMUX or os.getenv("MYTMUX")
            tmux = tmux ~= "" and tmux or "tmux"
            cmd = tmux .. " new-session -s" .. " nvim-" .. vim.loop.os_getpid() .. " " .. os.getenv("SHELL")
          end
          Snacks.terminal(cmd, { cwd = LazyVim.root() })
        end,
        mode = { "n", "i", "v", "t" },
        desc = "Tmux (Root Dir)",
      },
      {
        "<leader>dr",
        function()
          local fileType = vim.opt.filetype:get()
          local fileExt = vim.fn.expand("%:e")

          local fileDir = vim.fn.expand("%:p:h")
          local fileNameWithoutExt = vim.fn.expand("%:t:r")
          local fileName = vim.fn.expand("%:t")
          local filePath = vim.fn.expand("%:p")

          local tmpFileDir = "/tmp/lf-img" .. fileDir
          local tmpFileNameWithoutExt = exec("sha256sum '" .. filePath .. "' | awk '{print $1}'")
          local tmpFileName = tmpFileNameWithoutExt .. ".png"
          local tmpFilePath = tmpFileDir .. "/" .. tmpFileName

          local cmd

          if fileName == "Makefile" then
            cmd = ("cd '%s'; make"):format(fileDir)
          elseif fileExt == "png" or fileExt == "jpg" or fileExt == "gif" or fileExt == "svg" then
            cmd = ("cd '%s'; chafa '%s'"):format(fileDir, fileName)
          elseif fileExt == "drawio" then
            cmd = ("cd '%s'; [ ! -f '%s' ] && mkdir -p '%s' && drawio '%s' --no-sandbox -x -f png -s 0.75 -o '%s' >/dev/null; chafa '%s'"):format(
              fileDir,
              tmpFilePath,
              tmpFileDir,
              fileName,
              tmpFilePath,
              tmpFilePath
            )
          elseif
            fileExt == "doc"
            or fileExt == "docx"
            or fileExt == "ppt"
            or fileExt == "pptx"
            or fileExt == "xls"
            or fileExt == "xlsx"
          then
            local tmp
            if fileExt == "doc" or fileExt == "docx" then
              tmp = "writer_pdf_Export"
            elseif fileExt == "ppt" or fileExt == "pptx" then
              tmp = "impress_pdf_Export"
            elseif fileExt == "xls" or fileExt == "xlsx" then
              tmp = "calc_pdf_Export"
            end
            cmd = ([[cd '%s'; [ ! -f '%s' ] && mkdir -p '%s' && libreoffice --headless --convert-to 'pdf:%s:{"PageRange":{"type":"string","value":"1"},"Quality":{"type":"long","value":"25"},"MaxImageResolution":{"type":"long","value":"75"}}' --outdir '%s' '%s' >/dev/null && mv '%s' '%s' && pdftoppm -f 1 -l 1 -png -r 72 -aa no -aaVector no '%s' >'%s'; chafa '%s']]):format(
              fileDir,
              tmpFilePath,
              tmpFileDir,
              tmp,
              tmpFileDir,
              fileName,
              tmpFileDir .. "/" .. fileNameWithoutExt .. ".pdf",
              tmpFileDir .. "/" .. tmpFileNameWithoutExt .. ".pdf",
              tmpFileDir .. "/" .. tmpFileNameWithoutExt .. ".pdf",
              tmpFilePath,
              tmpFilePath
            )
          elseif fileType == "pdf" then
            cmd = ("cd '%s'; [ ! -f '%s' ] && pdftoppm -f 1 -l 1 -png -r 72 -aa no -aaVector no '%s' >'%s'; chafa '%s'"):format(
              fileDir,
              tmpFilePath,
              fileName,
              tmpFilePath,
              tmpFilePath
            )
          elseif fileType == "python" then
            cmd = ("cd '%s'; python '%s'"):format(fileDir, fileName)
          elseif fileType == "sh" then
            cmd = ("cd '%s'; bash '%s'"):format(fileDir, fileName)
          elseif fileType == "c" then
            cmd = ("cd '%s'; gcc '%s' -o '%s' && './%s'"):format(
              fileDir,
              fileName,
              fileNameWithoutExt,
              fileNameWithoutExt
            )
          end
          if not cmd then
            return
          end
          Snacks.terminal(cmd, {
            cwd = LazyVim.root(),
            interactive = false,
            win = {
              on_buf = function()
                vim.cmd.startinsert()
              end,
            },
          })
        end,
        desc = "Debug run command for current filetype",
      },
      {
        "<leader>\\",
        function()
          Snacks.terminal(vim.fn.input(""), { cwd = LazyVim.root(), interactive = true })
        end,
        desc = "Run custom command in snacks terminal",
      },
      -- {
      --   "<C-9>",
      --   function()
      --     Snacks.terminal("lf", { cwd = LazyVim.root(), interactive = true })
      --   end,
      --   mode = { "n", "t" },
      --   desc = "Run lf in snacks terminal",
      -- },
      -- {
      --   "<C-0>",
      --   function()
      --     Snacks.terminal(_G.localhost.GEMINI or "gemini", { cwd = LazyVim.root(), interactive = true })
      --   end,
      --   mode = { "n", "t" },
      --   desc = "Run gemini in snacks terminal",
      -- },
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
    },
  },
  {
    "folke/snacks.nvim",
    opts = function()
      -- if vim.uv.os_uname().sysname:find("Windows") == nil then
      if not LazyVim.is_win() then
        -- NOTE: Clean dangling tmux sessions
        -- TODO: No effect on VimEnter, so disable it for now. Need to further investigate.
        -- vim.api.nvim_create_autocmd({ "VimEnter", "VimLeave" }, {
        vim.api.nvim_create_autocmd("VimLeave", {
          callback = function(args)
            local tmux = _G.localhost.MYTMUX or os.getenv("MYTMUX")
            tmux = tmux ~= "" and tmux or "tmux"

            -- Get all tmux sessions that have a name starting with "nvim-".
            local stdout = vim.system({ tmux, "ls", "-F", '"#{session_name}"' }, { text = true }):wait().stdout
            if not stdout then
              return
            end
            local tmux_sessions = {}
            for line in stdout:gmatch("[^\r\n]+") do
              line = line:match('"(nvim%-.*)"')
              table.insert(tmux_sessions, line)
            end

            -- If VimEnter and VimLeave, clear the tmux sessions that have no corresponding nvim process.
            for _, line in ipairs(tmux_sessions) do
              local pid = line:match("nvim%-([%w]+)")
              local pname = vim.system({ "ps", "-p", pid, "-o", "args=" }, { text = true }):wait().stdout
              if not pname or not pname:find("nvim%s+%-%-embed") then
                vim.system({ tmux, "kill-session", "-t", line }, { text = true })
              end
            end

            -- If VimLeave, clear the tmux session that corresponds to the current nvim process.
            if args.event == "VimLeave" then
              local pid = vim.loop.os_getpid()
              local pname = vim.system({ "ps", "-p", pid, "-o", "args=" }, { text = true }):wait().stdout
              if pname and pname:find("nvim%s+%-%-embed") then
                vim.system({ tmux, "kill-session", "-t", "nvim-" .. pid }, { text = true })
              end
            end
          end,
        })
      end
    end,
  },
  {
    "glacambre/firenvim",
    custom = true,
    build = function()
      vim.fn["firenvim#install"](0)
    end,
    -- Lazy load firenvim
    -- Explanation: https://github.com/folke/lazy.nvim/discussions/463#discussioncomment-4819297
    cond = not not vim.g.started_by_firenvim,
    config = function() -- NOTE: Must be in `config` instead of `opts`, otherwise firenvim will complain.
      vim.api.nvim_create_autocmd("UIEnter", {
        callback = function()
          local client = vim.api.nvim_get_chan_info(vim.v.event.chan).client
          if client and client.name == "Firenvim" then
            vim.opt.guifont = "FiraCode Nerd Font:h25"
            vim.opt.laststatus = 0
            vim.opt.swapfile = false
          end
        end,
      })
      vim.api.nvim_create_autocmd("BufEnter", {
        pattern = { "github.com_*.txt", "gitee.com_*.txt" },
        callback = function()
          vim.opt.filetype = "markdown"
        end,
      })
      vim.api.nvim_create_autocmd("BufEnter", {
        pattern = { "leetcode.com_*.txt", "leetcode.cn_*.txt" },
        callback = function()
          vim.opt.filetype = "python"
          vim.opt.expandtab = true
        end,
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
        },
      }
    end,
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
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      current_line_blame_opts = {
        delay = 0,
      },
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    opts = function()
      -- Check if we need to reload the gitsigns when it changed
      vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
        callback = function()
          if package.loaded["gitsigns"] and vim.o.buftype ~= "nofile" then
            require("gitsigns").reset_base()
          end
        end,
      })
    end,
  },
  {
    "akinsho/bufferline.nvim",
    opts = {
      options = {
        mode = "tabs",
        show_buffer_close_icons = false,
        show_close_icon = false,
      },
    },
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
      },
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
    opts = {},
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    opts = {
      scope = { enabled = false },
    },
  },
  {
    "kevinhwang91/nvim-hlslens",
    custom = true,
    keys = {
      { "/" },
      { "?" },
      {
        "n",
        function()
          vim.cmd("normal! " .. vim.v.count1 .. "n")
          require("hlslens").start()
        end,
        mode = { "n", "v" },
        silent = true,
      },
      {
        "N",
        function()
          vim.cmd("normal! " .. vim.v.count1 .. "N")
          require("hlslens").start()
        end,
        mode = { "n", "v" },
        silent = true,
      },
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
  -- {
  --   "zbirenbaum/copilot.lua",
  --   opts = {
  --     suggestion = {
  --       keymap = {
  --         accept_line = "<C-l>",
  --       },
  --     },
  --   },
  -- },
  -- {
  --   -- NOTE: "lazyvim.plugins.extras.ai.copilot-chat",
  --   "CopilotC-Nvim/CopilotChat.nvim",
  --   keys = {
  --     {
  --       "<C-9>",
  --       function()
  --         return require("CopilotChat").toggle()
  --       end,
  --       desc = "Toggle (CopilotChat)",
  --       mode = { "n", "v" },
  --       remap = true,
  --     },
  --   },
  --   build = "make tiktoken", -- Only on MacOS or Linux
  --   opts = {
  --     model = (_G.localhost.OPENAI_MODEL or os.getenv("OPENAI_MODEL") or "moonshotai/Kimi-K2-Instruct"),
  --     window = {
  --       layout = "float",
  --       width = 0.8, -- fractional width of parent, or absolute width in columns when > 1
  --       height = 0.8, -- fractional height of parent, or absolute height in rows when > 1
  --     },
  --     mappings = {
  --       close = {
  --         normal = "<C-9>",
  --         insert = "<C-9>",
  --       },
  --       reset = {
  --         callback = function()
  --           require("CopilotChat").reset()
  --           vim.defer_fn(function()
  --             vim.cmd("startinsert")
  --           end, 100)
  --         end,
  --       },
  --     },
  --     providers = {
  --       openai = {
  --         prepare_input = require("CopilotChat.config.providers").copilot.prepare_input,
  --         prepare_output = require("CopilotChat.config.providers").copilot.prepare_output,
  --         get_headers = function()
  --           return {
  --             ["Authorization"] = "Bearer " .. (_G.localhost.OPENAI_API_KEY or os.getenv("OPENAI_API_KEY")),
  --           }
  --         end,
  --         get_models = function(headers)
  --           local response, err = require("CopilotChat.utils").curl_get(
  --             (_G.localhost.OPENAI_API_URL or os.getenv("OPENAI_API_URL") or "https://api.siliconflow.cn/v1")
  --               .. "/models",
  --             {
  --               headers = headers,
  --               json_response = true,
  --             }
  --           )
  --           if err then
  --             error(err)
  --           end
  --           return vim.tbl_map(function(model)
  --             return {
  --               id = model.id,
  --               name = model.id,
  --             }
  --           end, response.body.data)
  --         end,
  --         embed = function(inputs, headers)
  --           local response, err = require("CopilotChat.utils").curl_post(
  --             (_G.localhost.OPENAI_API_URL or os.getenv("OPENAI_API_URL") or "https://api.siliconflow.cn/v1")
  --               .. "/embeddings",
  --             {
  --               headers = headers,
  --               json_request = true,
  --               json_response = true,
  --               body = {
  --                 input = inputs,
  --                 model = (
  --                   _G.localhost.OPENAI_MODEL_EMBED
  --                   or os.getenv("OPENAI_MODEL_EMBED")
  --                   or "Qwen/Qwen3-Embedding-0.6B"
  --                 ),
  --               },
  --             }
  --           )
  --           if err then
  --             error(err)
  --           end
  --           return response.body.data
  --         end,
  --         get_url = function()
  --           return (_G.localhost.OPENAI_API_URL or os.getenv("OPENAI_API_URL") or "https://api.siliconflow.cn/v1")
  --             .. "/chat/completions"
  --         end,
  --       },
  --     },
  --   },
  -- },
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
        component_separators = { left = "", right = "" },
      },
      sections = {
        lualine_z = {
          function()
            -- local date = vim.loop.os_uname().sysname == "Darwin" and "gdate" or "date"
            -- return " " .. vim.system({ date, "+%H:%M:%S.%3N" }, { text = true }):wait().stdout:gsub("\n", "")
            local now = os.date("*t")
            -- local seconds = os.clock()
            -- local milliseconds = math.floor((seconds - math.floor(seconds)) * 1000)
            -- return string.format(" %02d:%02d:%02d.%03d", now.hour, now.min, now.sec, milliseconds)
            return string.format(" %02d:%02d:%02d", now.hour, now.min, now.sec)
          end,
        },
      },
    },
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
  --   -- NOTE: Use this below to enable all symbols.
  --   "hedyhli/outline.nvim",
  --   opts = function(_, opts)
  --     opts.symbols.filter = nil
  --   end,
  -- },
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
            ["ctrl-o"] = fzf_lua.actions.toggle_ignore,
          },
        },
        grep = {
          actions = {
            ["alt-h"] = false,
            ["alt-i"] = false,
            ["ctrl-y"] = fzf_lua.actions.toggle_hidden,
            ["ctrl-o"] = fzf_lua.actions.toggle_ignore,
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
        },
      }
    end,
  },
  {
    "tpope/vim-rsi",
    custom = true,
    event = "InsertEnter",
  },
  {
    "gbprod/yanky.nvim",
    dependencies = { "kkharji/sqlite.lua", custom = true },
    opts = {
      ring = { storage = "sqlite" },
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
    -- NOTE: This plugin is imported by LazyVim.
    -- So if you want to disable it, you need to set `enabled = false` here. Not just comment it out.
    "MeanderingProgrammer/render-markdown.nvim",
    -- NOTE: Disable it for now since it messes up with markdown, and I don't use Avante now.
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
    end,
  },
  {
    "jiaoshijie/undotree",
    custom = true,
    dependencies = "nvim-lua/plenary.nvim",
    keys = {
      {
        "<leader>ut",
        function()
          require("undotree").toggle()
        end,
        desc = "Toggle undotree",
      },
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
        end,
      })
    end,
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
        end,
      })
    end,
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
        end,
      })
    end,
  },
  {
    "AndrewRadev/linediff.vim",
    custom = true,
    cmd = "Linediff",
  },
  {
    "kevinhwang91/nvim-fundo",
    custom = true,
    lazy = false,
    dependencies = "kevinhwang91/promise-async",
    build = function()
      require("fundo").install()
    end,
    config = function() -- NOTE: This plugin is required to be configured specifically. The `config = true` will not work.
      require("fundo").setup({
        archives_dir = vim.fn.stdpath("state") .. "/fundo",
      })
    end,
  },
  {
    -- NOTE: Paste from https://github.com/yetone/avante.nvim?tab=readme-ov-file#installation
    -- support for image pasting
    "HakonHarnes/img-clip.nvim",
    custom = true,
    keys = {
      -- suggested keymap
      {
        "<leader>P",
        function()
          return (package.loaded["avante"] and vim.bo.filetype == "AvanteInput")
              and require("avante.clipboard").paste_image()
            or require("img-clip").paste_image()
        end,
        desc = "Paste image from system clipboard",
      },
    },
    opts = {
      -- recommended settings
      default = {
        dir_path = function()
          return ".assets/" .. vim.fn.expand("%:t:r") .. "/img"
        end,
        relative_to_current_file = true,
        -- drag_and_drop = {
        --   insert_mode = true,
        -- },
        -- required for Windows users
        use_absolute_path = LazyVim.is_win(),
      },
      filetypes = {
        markdown = {
          template = '<p><img src="$FILE_PATH" alt="$CURSOR" width=100% style="display: block; margin: auto;"></p>',
        },
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
  -- {
  --   "dhruvasagar/vim-table-mode",
  --   custom = true,
  --   ft = "markdown",
  --   cmd = "TableModeToggle",
  --   keys = {
  --     { "<leader>tm", "<Plug>TableModeToggle", desc = "Toggle table mode" },
  --   },
  -- },
  {
    "hat0uma/csvview.nvim",
    custom = true,
    ft = "csv",
    cmd = { "CsvViewEnable", "CsvViewDisable", "CsvViewToggle" },
    keys = {
      { "<leader>cv", "<CMD>CsvViewToggle<CR>", mode = "n", silent = true, desc = "Toggle CsvView" },
    },
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
  {
    "iamcco/markdown-preview.nvim",
    init = function() -- NOTE: Must be `init` here, otherwise it will complain.
      vim.g.mkdp_auto_close = 0
      vim.g.mkdp_combine_preview = 1
      vim.g.mkdp_echo_preview_url = 1
      vim.g.mkdp_open_to_the_world = 1
    end,
  },
  -- {
  --   "JunYang-tes/gemini-nvim",
  --   custom = true,
  --   keys = {
  --     { "<C-9>", "<CMD>Gemini<CR>", mode = { "n", "t" }, silent = true, desc = "Toggle Gemini Window" },
  --   },
  --   opts = {
  --     agents = {
  --       {
  --         name = "Gemini",
  --         program = _G.localhost.GEMINI or "gemini",
  --       },
  --     },
  --     toggle_keymap = "<C-9>",
  --   },
  -- },
  {
    "Zeioth/markmap.nvim",
    -- NOTE: Forks:
    -- https://github.com/Zeioth/markmap.nvim/compare/main...qmrodgers:markmap.nvim:main
    -- https://github.com/Zeioth/markmap.nvim/compare/main...nixenjoyer:markmap.nvim:feat/markmap_cmd-in-config
    -- https://github.com/MarcoBuess/markmap.nvim/compare/main...kirasok:markmap.nvim:main
    -- https://github.com/Zeioth/markmap.nvim/compare/main...MarcoBuess:markmap.nvim:feat/mms-default-path
    -- https://github.com/Zeioth/markmap.nvim/compare/main...MarcoBuess:markmap.nvim:main
    -- https://github.com/Zeioth/markmap.nvim/pull/8/files
    -- https://github.com/Zeioth/markmap.nvim/pull/6/files
    build = "npm install -g markmap-cli",
    cmd = { "MarkmapOpen", "MarkmapSave", "MarkmapWatch", "MarkmapWatchStop" },
    opts = {}, -- NOTE: Must manually declare this.
  },
  {
    "jbmorgado/vim-pine-script",
    custom = true,
    ft = "psl",
    config = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "psl",
        callback = function()
          vim.opt_local.commentstring = "// %s"
        end,
      })
    end,
  },
}
