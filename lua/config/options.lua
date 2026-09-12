vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local opt = vim.opt
opt.autowrite = true -- Enable auto write
opt.clipboard = "unnamedplus" -- Sync with system clipboard
opt.completeopt = "menu,menuone,noselect"
opt.conceallevel = 2 -- Hide * markup for bold and italic, but not markers with substitutions
opt.confirm = true -- Confirm to save changes before exiting modified buffer
opt.cursorline = true -- Enable highlighting of the current line
opt.expandtab = true -- Use spaces instead of tabs
opt.formatoptions = "jcroqlnt" -- tcqj
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"
opt.ignorecase = true -- Ignore case
opt.inccommand = "nosplit" -- preview incremental substitute
opt.laststatus = 3 -- global statusline
opt.list = true -- Show some invisible characters (tabs...
opt.mouse = "a" -- Enable mouse mode
opt.number = true -- Print line number
opt.pumblend = 10 -- Popup blend
opt.pumheight = 10 -- Maximum number of entries in a popup
opt.relativenumber = true -- Relative lines in normal mode; absolute lines while inserting
opt.scrolloff = 4 -- Lines of context
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }
opt.shiftround = true -- Round indent
opt.shiftwidth = 2 -- Size of an indent
opt.shortmess:append({ W = true, I = true, c = true, C = true })
opt.showmode = false -- Dont show mode since we have a statusline
opt.sidescrolloff = 8 -- Columns of context
opt.signcolumn = "yes" -- Always show the signcolumn, otherwise it would shift the text each time
opt.smartcase = true -- Don't ignore case with capitals
opt.smartindent = true -- Insert indents automatically
opt.smoothscroll = true
opt.spelllang = { "en" }
opt.splitbelow = true -- Put new windows below current
opt.splitkeep = "screen"
opt.splitright = true -- Put new windows right of current
opt.tabstop = 2 -- Number of spaces tabs count for
opt.timeoutlen = 300 -- Lower timeout to register keymaps (default 1000)
opt.undofile = true
opt.undolevels = 10000
opt.updatetime = 200 -- Save swap file and trigger CursorHold
opt.virtualedit = "block" -- Allow cursor to move where there is no text in visual block mode
opt.wildmode = "longest:full,full" -- Command-line completion mode
opt.winminwidth = 5 -- Minimum window width
opt.wrap = false -- Disable line wrap

if vim.fn.has("nvim-0.10") == 1 then
  opt.smoothscroll = true
end
local relative_number_group = vim.api.nvim_create_augroup("SmartRelativeNumber", { clear = true })
local relative_numbers = {}

vim.api.nvim_create_autocmd("InsertEnter", {
  group = relative_number_group,
  callback = function()
    local winid = vim.api.nvim_get_current_win()
    relative_numbers[winid] = vim.wo[winid].relativenumber
    vim.wo[winid].relativenumber = false
  end,
})

vim.api.nvim_create_autocmd("InsertLeave", {
  group = relative_number_group,
  callback = function()
    local winid = vim.api.nvim_get_current_win()
    local relative_number = relative_numbers[winid]
    if relative_number ~= nil then
      vim.wo[winid].relativenumber = relative_number
      relative_numbers[winid] = nil
    end
  end,
})
