return {
  "nyoom-engineering/oxocarbon.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    vim.cmd [[ colorscheme oxocarbon ]]

    -- Make the highlighted search text in the Snacks picker stand out (cyan/blue)
    vim.api.nvim_set_hl(0, "SnacksPickerMatch", { fg = "#33b1ff", bold = true, force = true })

    -- Oxocarbon makes unmatched text black on the selected line.
    -- This removes that black foreground and uses a nice dark grey background instead.
    vim.api.nvim_set_hl(0, "SnacksPickerListCursorLine", { bg = "#262626", fg = "NONE", force = true })

    -- Make the directory paths brighter so they don't blend into the background
    vim.api.nvim_set_hl(0, "SnacksPickerDir", { fg = "#8c8c8c", force = true })
  end,
}
