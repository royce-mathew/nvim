local calls = {}

package.preload.vscode = function()
  return {
    action = function(command, options)
      table.insert(calls, { method = "action", command = command, options = options })
    end,
    call = function(command, options)
      table.insert(calls, { method = "call", command = command, options = options })
    end,
    notify = function() end,
    with_insert = function(callback)
      callback()
    end,
  }
end

vim.g.vscode = true
vim.g.vscode_clipboard = { name = "vscode" }
dofile(vim.fn.getcwd() .. "/init.lua")

assert(vim.g.mapleader == " ")
assert(vim.g.clipboard.name == "vscode")
assert(package.loaded["config.lazy"])
assert(package.loaded["config.options"] == nil)
assert(package.loaded["config.keymaps"] == nil)

local plugins = require("lazy.core.config").plugins
assert(plugins["flash.nvim"])
assert(plugins["mini.pairs"])
assert(plugins["nvim-treesitter"])
assert(not plugins["mason.nvim"])
assert(vim.fn.maparg("]f", "n") ~= "")

local function invoke(lhs, mode)
  local mapping = vim.fn.maparg(lhs, mode, false, true)
  assert(type(mapping.callback) == "function", lhs .. " is not a callback mapping")
  mapping.callback()
end

invoke("<leader>ff", "n")
assert(calls[#calls].method == "action")
assert(calls[#calls].command == "workbench.action.quickOpen")

invoke("<leader>cf", "n")
assert(calls[#calls].method == "call")
assert(calls[#calls].command == "editor.action.formatDocument")

invoke("<leader>cf", "x")
assert(calls[#calls].method == "call")
assert(calls[#calls].command == "editor.action.formatSelection")

invoke("<leader>rn", "n")
assert(calls[#calls].method == "action")
assert(calls[#calls].command == "editor.action.rename")

invoke("<C-s>", "i")
assert(calls[#calls].method == "action")
assert(calls[#calls].command == "workbench.action.files.save")
