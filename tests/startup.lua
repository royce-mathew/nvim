vim.cmd.edit(vim.fn.tempname() .. ".rs")
assert(vim.treesitter.highlighter.active[vim.api.nvim_get_current_buf()])
assert(vim.fn.maparg("]f", "n") ~= "")
local servers = require("lazy.core.config").plugins["nvim-lspconfig"].opts.servers
assert(servers.ts_ls and not servers.tsserver)
assert(vim.tbl_contains(require("mason-lspconfig").get_available_servers(), "ts_ls"))
local _, toml_icon_hl = Snacks.util.icon("Cargo.toml", "file")
assert(toml_icon_hl == "DevIconToml")
assert(vim.api.nvim_get_hl(0, { name = "SnacksPickerGitStatusUntracked", link = true }).link == "Normal")


local messages = vim.fn.execute("messages")
assert(not messages:find("Failed to run config for nvim-treesitter", 1, true), messages)
assert(not messages:find("nvim-treesitter.configs", 1, true), messages)
assert(not messages:find("mason-lspconfig.nvim failed to install pyright", 1, true), messages)
assert(not messages:find("mason-lspconfig.nvim failed to install eslint", 1, true), messages)
assert(not messages:find("tsserver", 1, true), messages)
