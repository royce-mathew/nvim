return {
  -- Mason: package manager for LSP servers, formatters, linters
  {
    "mason-org/mason.nvim",
    opts = {},
  },

  -- Mason-lspconfig: LSP server registry
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig",
    },
  },

  -- nvim-lspconfig: LSP configurations
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "b0o/schemastore.nvim",
      "saghen/blink.cmp",
    },
    opts = {
      -- List of servers to install and configure
      servers = {
        eslint = {},
        jsonls = {},
        lua_ls = {},
        pyright = {},
        rust_analyzer = {},
        taplo = {},
        ts_ls = {},
        yamlls = {},
      },
      setup = {},
    },
    config = function(_, opts)
      local schemastore = require("schemastore")
      opts.servers.jsonls.settings = {
        json = {
          schemas = schemastore.json.schemas(),
          validate = { enable = true },
        },
      }
      opts.servers.yamlls.settings = {
        yaml = {
          keyOrdering = false,
          schemaStore = { enable = false, url = "" },
          schemas = schemastore.yaml.schemas(),
        },
      }

      -- Keep diagnostics in signs and pickers without overriding syntax highlights.
      vim.diagnostic.config({ underline = false })

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
        jsonls = true,
        pyright = true,
        ts_ls = true,
        yamlls = true,
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
        group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
        callback = function(ev)
          local opts = { buffer = ev.buf }

          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
          vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
          vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
          vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
          vim.keymap.set({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, opts)
        end,
      })
    end,
  },
}