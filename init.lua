vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

if vim.g.vscode then
  require("config.vscode")
  return
end

require("config.options")
require("config.deps")
require("config.lazy").setup("plugins")
require("config.autocmds")
require("config.keymaps")

