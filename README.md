# nvim-config

## Requirements
[Fira Code Nerd Font](https://www.nerdfonts.com/)

## VS Code Neovim

When started by [vscode-neovim](https://marketplace.visualstudio.com/items?itemName=asvetliakov.vscode-neovim), this configuration detects `vim.g.vscode` and loads `lua/config/vscode.lua` instead of the regular Neovim setup. It starts Lazy with only Flash, mini.pairs, and Treesitter textobjects; Treesitter highlighting and autotag remain disabled. VS Code provides language servers, completion, formatting, linting, diagnostics, and UI.

The VS Code path keeps the space leader and provides these mappings:

- `<leader><space>` / `<leader>ff`: Quick Open
- `<leader>sg` / `<leader>sw`: find in files / word under cursor
- `<leader>e`, `<leader>,`, `<leader>fr`: Explorer, open editors, recent files
- `<leader>cf`, `<leader>rn`, `<leader>ca`: format, rename, code action
- `[d` / `]d`, `[h` / `]h`: previous/next diagnostic or Git change
- `<S-h>` / `<S-l>` and `<C-h/j/k/l>`: editor and editor-group navigation
- `<leader>-` / `<leader>|`: split below / right
- `s` / `S` and Treesitter textobject motions such as `]f` / `[f`: Flash and structural navigation

VS Code's built-in vscode-neovim navigation mappings remain responsible for `gd`, `gD`, `gr`, `K`, and related code-navigation commands. Use VS Code settings for editor appearance, language servers, formatting, completion, and keyboard passthroughs.

