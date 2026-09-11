local map = vim.keymap.set

return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    dependencies = {
        { "nvim-tree/nvim-web-devicons", opts = { default = true } },
    },
    opts = {
        bigfile = { enabled = true },
        dashboard = { enabled = true },
        explorer = { enabled = true },
        indent = { enabled = true },
        input = { enabled = true },
        picker = { enabled = true },
        notifier = { enabled = true },
        quickfile = { enabled = true },
        scope = { enabled = true },
        scroll = { enabled = true },
        statuscolumn = { enabled = true },
        words = { enabled = true },
    },
    config = function(_, opts)
        local snacks = require("snacks")
        snacks.setup(opts)

        local function apply_untracked_git_status_highlight()
            -- Normal's background would cover the picker cursor line, so copy only its readable foreground.
            local normal = vim.api.nvim_get_hl(0, { name = "Normal", link = false })
            vim.api.nvim_set_hl(0, "SnacksPickerGitStatusUntracked", { fg = normal.fg })
        end

        vim.api.nvim_create_autocmd("ColorScheme", {
            group = vim.api.nvim_create_augroup("UserSnacksHighlights", { clear = true }),
            callback = apply_untracked_git_status_highlight,
        })
        apply_untracked_git_status_highlight()
    end,
    init = function()
        vim.api.nvim_create_autocmd("User", {
            pattern = "VeryLazy",
            callback = function()
                -- toggle options
                Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
                Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
                Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
                Snacks.toggle.diagnostics():map("<leader>ud")
                Snacks.toggle.line_number():map("<leader>ul")
                Snacks.toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2, name = "Conceal Level" }):map("<leader>uc")
                Snacks.toggle.option("showtabline", { off = 0, on = vim.o.showtabline > 0 and vim.o.showtabline or 2, name = "Tabline" }):map("<leader>uA")
                Snacks.toggle.treesitter():map("<leader>uT")
                Snacks.toggle.option("background", { off = "light", on = "dark" , name = "Dark Background" }):map("<leader>ub")
                Snacks.toggle.dim():map("<leader>uD")
                Snacks.toggle.animate():map("<leader>ua")
                Snacks.toggle.indent():map("<leader>ug")
                Snacks.toggle.scroll():map("<leader>uS")
                Snacks.toggle.profiler():map("<leader>dpp")
                Snacks.toggle.profiler_highlights():map("<leader>dph")


                -- git
                map("n", "<leader>gL", function() Snacks.picker.git_log() end, { desc = "Git Log (cwd)" })
                map("n", "<leader>gb", function() Snacks.picker.git_log_line() end, { desc = "Git Blame Line" })
                map("n", "<leader>gf", function() Snacks.picker.git_log_file() end, { desc = "Git Current File History" })
                map({ "n", "x" }, "<leader>gB", function() Snacks.gitbrowse() end, { desc = "Git Browse (open)" })
                map({"n", "x" }, "<leader>gY", function()
                Snacks.gitbrowse({ open = function(url) vim.fn.setreg("+", url) end, notify = false })
                end, { desc = "Git Browse (copy)" })


                -- windows
                map("n", "<leader>-", "<C-W>s", { desc = "Split Window Below", remap = true })
                map("n", "<leader>|", "<C-W>v", { desc = "Split Window Right", remap = true })
                map("n", "<leader>wd", "<C-W>c", { desc = "Delete Window", remap = true })
                Snacks.toggle.zoom():map("<leader>wm"):map("<leader>uZ")
                Snacks.toggle.zen():map("<leader>uz")

                if vim.lsp.inlay_hint then
                    Snacks.toggle.inlay_hints():map("<leader>uh")
                end
                
                -- buffer
                map("n", "<leader>bd", function()
                    Snacks.bufdelete()
                end, { desc = "Delete Buffer" })
                map("n", "<leader>bo", function()
                    Snacks.bufdelete.other()
                end, { desc = "Delete Other Buffers" })
                map("n", "<leader>bi", function()
                    Snacks.bufdelete.invisible()
                end, { desc = "Delete Invisible Buffers" })

                -- lua
                map({"n", "x"}, "<localleader>r", function() Snacks.debug.run() end, { desc = "Run Lua" })
            end,
        })
    end
}
