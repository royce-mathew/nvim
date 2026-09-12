return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      current_line_blame_opts = { delay = 300 },
      on_attach = function(bufnr)
        local gitsigns = require("gitsigns")
        local function map(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
        end

        map("n", "]h", gitsigns.next_hunk, "Next Git Hunk")
        map("n", "[h", gitsigns.prev_hunk, "Previous Git Hunk")
        map("n", "<leader>ghs", gitsigns.stage_hunk, "Stage Hunk")
        map("n", "<leader>ghr", gitsigns.reset_hunk, "Reset Hunk")
        map("v", "<leader>ghs", function()
          gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, "Stage Hunk")
        map("v", "<leader>ghr", function()
          gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, "Reset Hunk")
        map("n", "<leader>ghp", gitsigns.preview_hunk, "Preview Hunk")
        map("n", "<leader>ghb", gitsigns.blame_line, "Blame Line")
        map("n", "<leader>ghB", gitsigns.toggle_current_line_blame, "Toggle Line Blame")
        map("n", "<leader>ghd", gitsigns.diffthis, "Diff This")
      end,
    },
  },

  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    opts = {},
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics" },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics" },
      { "<leader>xL", "<cmd>Trouble loclist toggle<cr>", desc = "Location List" },
      { "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix List" },
    },
  },

  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = {
      options = vim.opt.sessionoptions:get(),
    },
    keys = {
      { "<leader>qs", "<cmd>PersistenceLoad<cr>", desc = "Restore Session" },
      { "<leader>qS", "<cmd>PersistenceSelect<cr>", desc = "Select Session" },
      { "<leader>ql", "<cmd>PersistenceLoadLast<cr>", desc = "Restore Last Session" },
    },
  },
}
