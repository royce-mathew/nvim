return {
  {
    "nvim-treesitter/nvim-treesitter",
    version = false,
    build = ":TSUpdate",
    lazy = false,
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      "windwp/nvim-ts-autotag",
    },
    config = function()
      local treesitter = require("nvim-treesitter")


      local function attach(bufnr)
        local language = vim.treesitter.language.get_lang(vim.bo[bufnr].filetype)
        if language and pcall(vim.treesitter.start, bufnr, language) then
          if vim.treesitter.query.get(language, "indents") then
            vim.bo[bufnr].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end
      end


      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("UserTreesitter", { clear = true }),
        callback = function(args)
          attach(args.buf)
        end,
      })
      -- A file passed on the command line receives FileType before Lazy configures this plugin.
      attach(vim.api.nvim_get_current_buf())


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