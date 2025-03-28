-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- ===
-- === Set by myself
-- ===
pcall(vim.cmd, "autocmd! nvim_swapfile")
vim.opt.lazyredraw = true
vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function()
    vim.opt.fileformat = "unix"
  end
})
-- Ref: https://www.reddit.com/r/neovim/comments/35h1g1/comment/cr4clpu/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
vim.opt.ttimeoutlen = 0
local timeoutlen
vim.api.nvim_create_autocmd("InsertEnter", {
  callback = function()
    timeoutlen = vim.opt.timeoutlen:get()
    vim.opt.timeoutlen = 0
  end
})
vim.api.nvim_create_autocmd("InsertLeave", {
  callback = function()
    if not timeoutlen then return end
    vim.opt.timeoutlen = timeoutlen
  end
})

-- Allow copy paste in Neovide
vim.g.neovide_input_use_logo = 1

-- ==
-- == Set by LazyVim, and modified by myself
-- ==
vim.opt.clipboard = ""
vim.opt.confirm = false
vim.opt.autowrite = false
vim.opt.conceallevel = 0
vim.opt.list = false
-- Ref: https://www.reddit.com/r/vim/comments/s9gqgr/smartindent_messing_with_comment_indents
-- Ref: https://www.reddit.com/r/vim/wiki/vimrctips/#wiki_do_not_use_smartindent
vim.opt.smartindent = false

vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.api.nvim_create_autocmd("FileType", {
  pattern = "lua",
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
  end
})
vim.api.nvim_create_autocmd("FileType", {
  pattern = "tex",
  callback = function()
    vim.opt_local.expandtab = false
    -- Ref: https://vi.stackexchange.com/a/34778
    vim.opt_local.indentexpr = ""
  end
})
vim.api.nvim_create_autocmd("FileType", {
  pattern = "nu",
  callback = function()
    vim.opt_local.commentstring = "# %s"
  end
})

vim.g.autoformat = false
vim.g.snacks_animate = false
vim.g.ai_cmp = false
-- vim.g.lazyvim_cmp = vim.system({ "which", "cargo" }):wait().code == 0 and vim.g.lazyvim_cmp or "nvim-cmp"
vim.g.root_spec = { "cwd" }
vim.g.lazyvim_python_lsp = "jedi_language_server"
vim.g.lazyvim_picker = "fzf"
