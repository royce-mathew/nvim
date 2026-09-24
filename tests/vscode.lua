local source = debug.getinfo(1, "S").source:sub(2)
local config_root = vim.fs.dirname(vim.fs.dirname(source))
vim.opt.rtp:prepend(config_root)

vim.g.vscode = true
local actions = {}
package.preload.vscode = function()
  return {
    action = function(command)
      actions[#actions + 1] = command
    end,
    call = function() end,
    notify = function() end,
    with_insert = function(callback)
      return callback()
    end,
  }
end
package.preload["config.lazy"] = function()
  return { setup = function() end }
end

require("config.vscode")

assert(vim.o.timeoutlen == 300)

local insert_mapping = vim.fn.maparg("jk", "i", false, true)
assert(insert_mapping.lhs == "jk")
assert(insert_mapping.rhs == "<Esc>")

local function assert_action_mapping(lhs, command)
  local mapping = vim.fn.maparg(lhs, "n", false, true)
  assert(mapping.callback)
  mapping.callback()
  assert(actions[#actions] == command)
end

assert_action_mapping("gi", "editor.action.goToImplementation")
assert_action_mapping("gI", "editor.action.goToImplementation")
assert_action_mapping("gy", "editor.action.goToTypeDefinition")
assert_action_mapping("<leader>xx", "workbench.actions.view.problems")
