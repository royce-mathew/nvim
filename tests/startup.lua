vim.cmd.edit(vim.fn.tempname() .. ".rs")
assert(vim.treesitter.highlighter.active[vim.api.nvim_get_current_buf()])
assert(vim.fn.maparg("]f", "n") ~= "")
local servers = require("lazy.core.config").plugins["nvim-lspconfig"].opts.servers
assert(servers.ts_ls and not servers.tsserver)
assert(vim.tbl_contains(require("mason-lspconfig").get_available_servers(), "ts_ls"))
local _, toml_icon_hl = Snacks.util.icon("Cargo.toml", "file")
assert(toml_icon_hl == "DevIconToml")
assert(vim.api.nvim_get_hl(0, { name = "SnacksPickerGitStatusUntracked", link = true }).link == "Normal")
local git_sign_colors = {
  GitSignsAdd = 0x358b4d,
  GitSignsChange = 0x5b7db8,
  GitSignsDelete = 0xad417c,
}
for name, color in pairs(git_sign_colors) do
  assert(vim.api.nvim_get_hl(0, { name = name }).fg == color)
end
assert(vim.api.nvim_get_hl(0, { name = "NormalFloat" }).bg == 0x202020)
assert(vim.g.mapleader == " ")
assert(vim.fn.maparg("gd", "n") ~= "")
assert(require("conform").formatters_by_ft.rust[1] == "rustfmt")
assert(require("lint").linters_by_ft.python[1] == "ruff")
assert(vim.fn.exists(":Copilot") == 2)

require("lazy").load({
  plugins = {
    "flash.nvim",
    "copilot.vim",
    "neotest",
    "nvim-dap",
    "persistence.nvim",
    "todo-comments.nvim",
    "trouble.nvim",
    "which-key.nvim",
  },
})
assert(vim.tbl_contains(require("mason-nvim-dap").get_available_sources(), "python"))
assert(vim.fn.exists(":Trouble") == 2)
assert(vim.g.copilot_no_tab_map)
local copilot_accept = vim.fn.maparg("<C-j>", "i", false, true)
assert(copilot_accept.expr and copilot_accept.rhs == 'copilot#Accept("\\<CR>")')


local messages = vim.fn.execute("messages")
assert(not messages:find("Failed to run config for nvim-treesitter", 1, true), messages)
assert(not messages:find("nvim-treesitter.configs", 1, true), messages)
assert(not messages:find("mason-lspconfig.nvim failed to install pyright", 1, true), messages)
assert(not messages:find("mason-lspconfig.nvim failed to install eslint", 1, true), messages)
assert(not messages:find("tsserver", 1, true), messages)
