# Keybinds

`<leader>` is Space. These are the daily-use mappings; use `<leader>sk` to search the complete map list.

## Find and navigate

| Key | Action |
|---|---|
| `<leader><space>` | Smart file finder |
| `<leader>ff` / `<leader>fg` | Find files / Git-tracked files |
| `<leader>sg` / `<leader>sw` | Grep project / word or selection |
| `<leader>e` | File explorer |
| `<leader>,` | Open buffers |
| `<leader>fr` / `<leader>fp` | Recent files / projects |
| `s` / `S` | Flash jump / Treesitter jump |
| `gd` / `gr` | Definition / references picker |
| `gI` / `gy` | Implementation / type definition picker |
| `gi` / `K` | Direct implementation / hover documentation |

## Code and diagnostics

| Key | Action |
|---|---|
| `<leader>cf` | Format buffer or selection |
| `<leader>rn` / `<leader>ca` | Rename symbol / code action |
| `<leader>cd` | Line diagnostics |
| `[d` / `]d` | Previous / next diagnostic |
| `[e` / `]e` | Previous / next error |
| `<leader>xx` / `<leader>xX` | Project / buffer diagnostics |
| `<leader>xQ` / `<leader>xL` | Quickfix / location list |

## Copilot

| Key | Action |
|---|---|
| `<C-j>` | Accept Copilot suggestion |

## Git

| Key | Action |
|---|---|
| `[h` / `]h` | Previous / next changed hunk |
| `<leader>ghs` / `<leader>ghr` | Stage / reset hunk |
| `<leader>ghp` / `<leader>ghb` | Preview hunk / blame line |
| `<leader>gs` / `<leader>gd` | Git status / changed hunks picker |
| `<leader>gg` | Lazygit |
| `<leader>gB` / `<leader>gY` | Open / copy remote Git URL |

## Tests and debugging

| Key | Action |
|---|---|
| `<leader>tt` / `<leader>tT` | Run nearest test / current test file |
| `<leader>tS` / `<leader>to` | Test summary / output |
| `<leader>dc` / `<leader>dl` | Continue / rerun last debug session |
| `<leader>db` / `<leader>dB` | Toggle / conditional breakpoint |
| `<leader>di` / `<leader>do` / `<leader>dO` | Step in / over / out |
| `<leader>dr` / `<leader>du` | Debug REPL / debug UI |

## Buffers, windows, and sessions

| Key | Action |
|---|---|
| `<C-s>` | Save |
| `<S-h>` / `<S-l>` | Previous / next buffer |
| `<leader>bd` / `<leader>bo` | Delete buffer / delete other buffers |
| `<C-h>` / `<C-j>` / `<C-k>` / `<C-l>` | Move between windows |
| `<leader>-` / `<leader>\|` | Split below / split right |
| `<C-/>` | Toggle terminal |
| `<leader>qs` / `<leader>ql` | Restore project / last session |
| `<leader>qS` | Select a session |

## Other useful commands

| Key | Action |
|---|---|
| `<leader>st` | Project TODO/FIXME list |
| `[t` / `]t` | Previous / next TODO/FIXME |
| `<leader>z` / `<leader>Z` | Zen mode / zoom current window |
| `<leader>l` | Lazy plugin manager |
| `<leader>sk` | Search all keybindings |
| `<leader>un` | Dismiss notifications |
