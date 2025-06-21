-- bootstrap lazy.nvim, LazyVim and your plugins
_G.localhost = {}
pcall(require, "localhost.pre") -- For setting up the _G.localhost
require("config.lazy")
pcall(require, "localhost.post")
