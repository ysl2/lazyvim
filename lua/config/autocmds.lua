-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Check if we need to reload the gitsigns when it changed
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  callback = function()
    if package.loaded["gitsigns"] and vim.o.buftype ~= "nofile" then
      require("gitsigns").reset_base()
    end
  end,
})

-- Auto delete [No Name] buffers.
vim.api.nvim_create_autocmd("BufLeave", {
  callback = function(args)
    if
      vim.api.nvim_buf_get_name(args.buf) == ""
      and not vim.bo[args.buf].modified
      and vim.fn.buflisted(args.buf) == 1
    then
      vim.schedule(function()
        pcall(vim.api.nvim_buf_delete, args.buf, { force = true })
      end)
    end
  end,
})
