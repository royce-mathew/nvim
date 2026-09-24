local M = {}

M.parsers = {
  "bash",
  "c",
  "css",
  "diff",
  "html",
  "javascript",
  "jsdoc",
  "json",
  "lua",
  "luadoc",
  "luap",
  "markdown",
  "markdown_inline",
  "printf",
  "python",
  "query",
  "regex",
  "rust",
  "toml",
  "tsx",
  "typescript",
  "vim",
  "vimdoc",
  "xml",
  "yaml",
}

function M.setup_parsers()
  local treesitter = require("nvim-treesitter")
  treesitter.setup({
    install_dir = vim.fn.stdpath("data") .. "/site",
  })
  if require("config.deps").treesitter_installer_ready() then
    treesitter.install(M.parsers)
  end
end

function M.setup_textobjects()
  local textobjects = require("nvim-treesitter-textobjects.move")
  require("nvim-treesitter-textobjects").setup({
    move = { set_jumps = true },
  })

  vim.keymap.set({ "n", "x", "o" }, "]f", function()
    textobjects.goto_next_start("@function.outer", "textobjects")
  end)
  vim.keymap.set({ "n", "x", "o" }, "]c", function()
    textobjects.goto_next_start("@class.outer", "textobjects")
  end)
  vim.keymap.set({ "n", "x", "o" }, "]a", function()
    textobjects.goto_next_start("@parameter.inner", "textobjects")
  end)
  vim.keymap.set({ "n", "x", "o" }, "]F", function()
    textobjects.goto_next_end("@function.outer", "textobjects")
  end)
  vim.keymap.set({ "n", "x", "o" }, "]C", function()
    textobjects.goto_next_end("@class.outer", "textobjects")
  end)
  vim.keymap.set({ "n", "x", "o" }, "]A", function()
    textobjects.goto_next_end("@parameter.inner", "textobjects")
  end)
  vim.keymap.set({ "n", "x", "o" }, "[f", function()
    textobjects.goto_previous_start("@function.outer", "textobjects")
  end)
  vim.keymap.set({ "n", "x", "o" }, "[c", function()
    textobjects.goto_previous_start("@class.outer", "textobjects")
  end)
  vim.keymap.set({ "n", "x", "o" }, "[a", function()
    textobjects.goto_previous_start("@parameter.inner", "textobjects")
  end)
  vim.keymap.set({ "n", "x", "o" }, "[F", function()
    textobjects.goto_previous_end("@function.outer", "textobjects")
  end)
  vim.keymap.set({ "n", "x", "o" }, "[C", function()
    textobjects.goto_previous_end("@class.outer", "textobjects")
  end)
  vim.keymap.set({ "n", "x", "o" }, "[A", function()
    textobjects.goto_previous_end("@parameter.inner", "textobjects")
  end)
end

return M
