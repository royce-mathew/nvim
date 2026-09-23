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
      local config = require("config.treesitter")
      config.setup_parsers()

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

      config.setup_textobjects()
    end,
  },

}
