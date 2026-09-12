return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-neotest/neotest-python",
      "rouge8/neotest-rust",
    },
    opts = function()
      return {
        adapters = {
          require("neotest-python")({ dap = { justMyCode = false } }),
          require("neotest-rust"),
        },
      }
    end,
    keys = {
      {
        "<leader>tt",
        function()
          require("neotest").run.run()
        end,
        desc = "Run Nearest Test",
      },
      {
        "<leader>tT",
        function()
          require("neotest").run.run(vim.fn.expand("%"))
        end,
        desc = "Run Test File",
      },
      {
        "<leader>ta",
        function()
          require("neotest").run.attach()
        end,
        desc = "Attach Test Output",
      },
      {
        "<leader>to",
        function()
          require("neotest").output.open({ enter = true, auto_close = true })
        end,
        desc = "Test Output",
      },
      {
        "<leader>tS",
        function()
          require("neotest").summary.toggle()
        end,
        desc = "Test Summary",
      },
    },
  },

  {
    "mfussenegger/nvim-dap",
    dependencies = { "jay-babu/mason-nvim-dap.nvim" },
    config = function()
      require("mason-nvim-dap").setup({
        ensure_installed = { "codelldb", "python", "js" },
        handlers = {},
      })
    end,
    keys = {
      { "<leader>dc", function() require("dap").continue() end, desc = "Debug Continue" },
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
      {
        "<leader>dB",
        function()
          require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
        end,
        desc = "Conditional Breakpoint",
      },
      { "<leader>di", function() require("dap").step_into() end, desc = "Debug Step Into" },
      { "<leader>do", function() require("dap").step_over() end, desc = "Debug Step Over" },
      { "<leader>dO", function() require("dap").step_out() end, desc = "Debug Step Out" },
      { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Debug REPL" },
      { "<leader>dl", function() require("dap").run_last() end, desc = "Debug Run Last" },
    },
  },

  {
    "jay-babu/mason-nvim-dap.nvim",
    lazy = true,
    dependencies = { "mason-org/mason.nvim" },
  },

  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "nvim-neotest/nvim-nio", "mfussenegger/nvim-dap" },
    opts = {},
    keys = {
      { "<leader>du", function() require("dapui").toggle() end, desc = "Debug UI" },
    },
    config = function(_, opts)
      local dap = require("dap")
      local dapui = require("dapui")
      dapui.setup(opts)

      dap.listeners.before.attach.dapui_config = dapui.open
      dap.listeners.before.launch.dapui_config = dapui.open
      dap.listeners.before.event_terminated.dapui_config = dapui.close
      dap.listeners.before.event_exited.dapui_config = dapui.close

    end,
  },
}
