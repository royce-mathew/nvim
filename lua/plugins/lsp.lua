return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      -- Adds extra capabilities from cmp if you add it later
      "saghen/blink.cmp",
    },
    opts = {
      -- List of servers to install and configure
      servers = {
        lua_ls = {},
        rust_analyzer = {},
        pyright = {},
        ts_ls = {},
        eslint = {},
      },
      setup = {},
    },
    config = function(_, opts)
      -- Setup Mason first
      require("mason").setup()
      
      -- Load blink.cmp capabilities if installed
      local has_blink, blink = pcall(require, "blink.cmp")
      local capabilities = vim.tbl_deep_extend(
        "force",
        {},
        vim.lsp.protocol.make_client_capabilities(),
        has_blink and blink.get_lsp_capabilities() or {}
      )
      
      -- Setup servers via mason-lspconfig
      local mason_lspconfig = require("mason-lspconfig")
      local servers = opts.servers
      local npm_servers = {
        eslint = true,
        pyright = true,
        ts_ls = true,
      }
      local ensure_installed = vim.tbl_filter(function(server)
        -- Keep system LSPs usable, but do not retry Mason packages without their npm prerequisite.
        return not npm_servers[server] or vim.fn.executable("npm") == 1
      end, vim.tbl_keys(servers))
      
      mason_lspconfig.setup({
        ensure_installed = ensure_installed,
      })
      
      for server, config in pairs(servers) do
        -- passing config.capabilities to blink.cmp adds proper completions
        config.capabilities = vim.tbl_deep_extend("force", {}, capabilities, config.capabilities or {})
        
        -- Use the modern Neovim 0.11+ built-in LSP configuration
        vim.lsp.config(server, config)
        vim.lsp.enable(server)
      end
      
      -- LspAttach autocommand for keymaps
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          local map_opts = { buffer = ev.buf }
          
          -- Essential modern navigation / actions
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, map_opts)
          vim.keymap.set("n", "K", vim.lsp.buf.hover, map_opts)
          vim.keymap.set("n", "gi", vim.lsp.buf.implementation, map_opts)
          vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, map_opts)
          vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, map_opts)
          vim.keymap.set({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, map_opts)
          vim.keymap.set("n", "gr", vim.lsp.buf.references, map_opts)
          
          -- Standard formatting trigger
          vim.keymap.set("n", "<space>f", function()
            vim.lsp.buf.format({ async = true })
          end, map_opts)
        end,
      })	
    end,
  }
}