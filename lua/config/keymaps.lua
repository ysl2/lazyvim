-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.del("n", "H")
vim.keymap.del("n", "L")
vim.keymap.del("v", "<")
vim.keymap.del("v", ">")
vim.keymap.del({ "n", "x" }, "j")
vim.keymap.del({ "n", "x" }, "k")
vim.keymap.del({ "n", "x", "o" }, "n")
vim.keymap.del({ "n", "x", "o" }, "N")

local function esc()
  vim.schedule(function()
    vim.cmd("noh")
    LazyVim.cmp.actions.snippet_stop()
  end)
  return "<esc>"
end
vim.keymap.set({ "i", "n", "s", "x" }, "<esc>", esc, { expr = true, desc = "Escape and Clear hlsearch" })
-- vim.keymap.set({ "i", "n", "s", "x", "c", "o" }, "<C-c>", esc, { desc = "Escape and Clear hlsearch" })
vim.keymap.set({ "i", "n", "s", "x", "c", "o" }, "<C-c>", "", { desc = "Disable <C-c>" })
-- NOTE: Use Alt-a/x to increment/decrement number under cursor, because <C-a> are widely used in tmux and terminal.
vim.keymap.del({ "i", "x", "n", "s" }, "<C-s>")
vim.keymap.set({ "n", "v" }, "<C-a>", "")
vim.keymap.set({ "n", "v" }, "<C-s>", "<C-a>", { desc = "Increment number under cursor" })
-- vim.keymap.set({ "n", "v" }, "<C-x>", "")
-- vim.keymap.set({ "n", "v" }, "<A-x>", "<C-x>", { desc = "Decrement number under cursor" })
vim.cmd([[
	" start of line
	:cnoremap <C-A>		<Home>
	" back one character
	:cnoremap <C-B>		<Left>
	" delete character under cursor
	:cnoremap <C-D>		<Del>
	" end of line
	:cnoremap <C-E>		<End>
	" forward one character
	:cnoremap <C-F>		<Right>
	" recall newer command-line
	:cnoremap <C-N>		<Down>
	" recall previous (older) command-line
	:cnoremap <C-P>		<Up>
	" " back one word
	" :cnoremap <Esc><C-B>	<S-Left>
	" " forward one word
	" :cnoremap <Esc><C-F>	<S-Right>
]])
vim.keymap.set("t", "<C-[>", "<C-\\><C-n>", { silent = true, desc = "Back to normal mode in terminal" })
vim.keymap.set("n", "<C-w>z", "<C-w>|<C-w>_", { silent = true, desc = "Maximize current window" })

-- Move buffers.
local function check_no_name_buffer(cmdstr)
  if vim.fn.empty(vim.fn.bufname(vim.fn.bufnr())) == 1 then
    return
  end
  vim.cmd(cmdstr)
end
vim.keymap.set("n", "<C-w><C-h>", function()
  return check_no_name_buffer("bel vs | silent! b# | winc p")
end, { silent = true, desc = "Move current buffer to left" })
vim.keymap.set("n", "<C-w><C-j>", function()
  return check_no_name_buffer("abo sp | silent! b# | winc p")
end, { silent = true, desc = "Move current buffer to down" })
vim.keymap.set("n", "<C-w><C-k>", function()
  return check_no_name_buffer("bel sp | silent! b# | winc p")
end, { silent = true, desc = "Move current buffer to up" })
vim.keymap.set("n", "<C-w><C-l>", function()
  return check_no_name_buffer("abo vs | silent! b# | winc p")
end, { silent = true, desc = "Move current buffer to right" })

-- Smart wrap
vim.keymap.set({ "n", "v" }, "k", function()
  return (vim.opt.wrap:get() and vim.v.count == 0) and "gk" or "k"
end, { expr = true, silent = true, desc = "Up (Smart Wrap)" })
vim.keymap.set({ "n", "v" }, "j", function()
  return (vim.opt.wrap:get() and vim.v.count == 0) and "gj" or "j"
end, { expr = true, silent = true, desc = "Down (Smart Wrap)" })
vim.keymap.set({ "n", "v" }, "0", function()
  return vim.opt.wrap:get() and "g0" or "0"
end, { expr = true, silent = true, desc = "Line Start (Smart Wrap)" })
vim.keymap.set({ "n", "v" }, "$", function()
  return vim.opt.wrap:get() and "g$" or "$"
end, { expr = true, silent = true, desc = "Line End (Smart Wrap)" })
vim.keymap.set({ "n", "v" }, "g0", function()
  return vim.opt.wrap:get() and "0" or "g0"
end, { expr = true, silent = true, desc = "Line Start (Smart Wrap)" })
vim.keymap.set({ "n", "v" }, "g$", function()
  return vim.opt.wrap:get() and "$" or "g$"
end, { expr = true, silent = true, desc = "Line End (Smart Wrap)" })
vim.keymap.set({ "n", "v" }, "<C-d>", function()
  return vim.opt.wrap:get() and "<C-d>g0" or "<C-d>"
end, { expr = true, silent = true, desc = "Half Page Down (Smart Wrap)" })
vim.keymap.set({ "n", "v" }, "<C-u>", function()
  return vim.opt.wrap:get() and "<C-u>g0" or "<C-u>"
end, { expr = true, silent = true, desc = "Half Page Up (Smart Wrap)" })
vim.keymap.set({ "n", "v" }, "gg", function()
  return vim.opt.wrap:get() and "gg0" or "gg"
end, { expr = true, silent = true, desc = "First Line (Smart Wrap)" })
vim.keymap.set({ "n", "v" }, "G", function()
  return vim.opt.wrap:get() and "G$g0" or "G"
end, { expr = true, silent = true, desc = "Last Line (Smart Wrap)" })
vim.keymap.set({ "n", "v" }, "gV", function()
  return vim.opt.wrap:get() and "g0vg$" or nil
end, { expr = true, silent = true, desc = "Select Line (Smart Wrap)" })

-- Diffview
vim.keymap.set("n", "<leader>da", function()
  local wins = vim.api.nvim_list_wins()
  local diff_wins = 0
  for _, win in ipairs(wins) do
    if vim.api.nvim_win_call(win, function()
      return vim.wo.diff
    end) then
      diff_wins = diff_wins + 1
    end
  end
  if diff_wins >= 2 then
    vim.cmd("diffoff!")
    return
  end
  if vim.wo.diff then
    vim.cmd("diffoff")
    return
  end
  vim.cmd("diffthis")
end, { silent = true, desc = "Diff this buffer" })
vim.keymap.set("n", "<leader>do", function()
  vim.cmd("diffoff!")
end, { silent = true, desc = "Diff off all buffers" })

-- For neovide/firenvim copy/paste in MacOS.
vim.keymap.set("n", "<D-v>", '"+p<CR>', { noremap = true, silent = true })
vim.keymap.set({ "i", "t" }, "<D-v>", "<C-R>+", { noremap = true, silent = true })
vim.keymap.set("v", "<D-c>", '"+y<CR>', { noremap = true, silent = true })

-- Ref: https://github.com/kevinhwang91/rnvimr/issues/76#issuecomment-1677064899
vim.cmd("cabbrev wqa wa\\|qa")
vim.cmd("cabbrev xa wa\\|qa")
