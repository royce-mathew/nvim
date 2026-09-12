return {
  -- nvim-treesitter: parser management and queries
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    version = false,
    build = ":TSUpdate",
    lazy = false,
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      "windwp/nvim-ts-autotag",
    },
    config = function()
      local treesitter = require("nvim-treesitter")
      local ensure_installed = {
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

      treesitter.setup({
        install_dir = vim.fn.stdpath("data") .. "/site",
      })
      treesitter.install(ensure_installed)

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("UserTreesitter", { clear = true }),
        callback = function(args)
          local language = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)
          if language and vim.treesitter.query.get(language, "highlights") then
            pcall(vim.treesitter.start, args.buf)
          end
        end,
      })


      require("nvim-ts-autotag").setup()

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
    end,
  },

}
