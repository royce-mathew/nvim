return {
  "github/copilot.vim",
  event = "InsertEnter",
  cmd = "Copilot",
  init = function()
    vim.g.copilot_no_tab_map = true
  end,
  config = function()
    vim.keymap.set("i", "<C-j>", 'copilot#Accept("\\<CR>")', {
      desc = "Accept Copilot suggestion",
      expr = true,
      replace_keycodes = false,
    })
  end,
}