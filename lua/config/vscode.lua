local vscode = require("vscode")
local map = vim.keymap.set

if vim.g.vscode_clipboard then
  vim.g.clipboard = vim.g.vscode_clipboard
end
vim.notify = vscode.notify

require("config.lazy").setup("config.vscode_plugins")

local function action(command, options)
  return function()
    vscode.action(command, options)
  end
end

local function format_document()
  vscode.call("editor.action.formatDocument")
end

local function format_selection()
  vscode.call("editor.action.formatSelection")
end

local function find_in_files()
  vscode.action("workbench.action.findInFiles", {
    args = { query = vim.fn.expand("<cword>") },
  })
end

map("n", "<leader><space>", action("workbench.action.quickOpen"), { desc = "Find Files" })
map("n", "<leader>ff", action("workbench.action.quickOpen"), { desc = "Find Files" })
map("n", "<leader>sg", action("workbench.action.findInFiles"), { desc = "Find in Files" })
map({ "n", "x" }, "<leader>sw", find_in_files, { desc = "Find Word" })
map("n", "<leader>e", action("workbench.view.explorer"), { desc = "File Explorer" })
map("n", "<leader>,", action("workbench.action.showAllEditors"), { desc = "Buffers" })
map("n", "<leader>fr", action("workbench.action.openRecent"), { desc = "Recent Files" })

map("n", "<leader>cf", format_document, { desc = "Format Document" })
map("x", "<leader>cf", format_selection, { desc = "Format Selection" })
map({ "n", "x" }, "<leader>rn", function()
  vscode.with_insert(function()
    vscode.action("editor.action.rename")
  end)
end, { desc = "Rename Symbol" })
map({ "n", "x" }, "<leader>ca", function()
  vscode.with_insert(function()
    vscode.action("editor.action.codeAction")
  end)
end, { desc = "Code Action" })
map("n", "<leader>cd", action("editor.action.showHover"), { desc = "Line Diagnostics" })
map("n", "]d", action("editor.action.marker.next"), { desc = "Next Diagnostic" })
map("n", "[d", action("editor.action.marker.prev"), { desc = "Previous Diagnostic" })

map("n", "]h", action("workbench.action.editor.nextChange"), { desc = "Next Git Hunk" })
map("n", "[h", action("workbench.action.editor.previousChange"), { desc = "Previous Git Hunk" })

map({ "i", "n", "x" }, "<C-s>", action("workbench.action.files.save"), { desc = "Save File" })
map("n", "<S-h>", action("workbench.action.previousEditor"), { desc = "Previous Editor" })
map("n", "<S-l>", action("workbench.action.nextEditor"), { desc = "Next Editor" })
map("n", "<C-h>", action("workbench.action.focusLeftGroup"), { desc = "Focus Left Editor Group" })
map("n", "<C-j>", action("workbench.action.focusBelowGroup"), { desc = "Focus Lower Editor Group" })
map("n", "<C-k>", action("workbench.action.focusAboveGroup"), { desc = "Focus Upper Editor Group" })
map("n", "<C-l>", action("workbench.action.focusRightGroup"), { desc = "Focus Right Editor Group" })
map("n", "<leader>-", action("workbench.action.splitEditorDown"), { desc = "Split Below" })
map("n", "<leader>|", action("workbench.action.splitEditorRight"), { desc = "Split Right" })
