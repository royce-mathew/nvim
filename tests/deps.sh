#!/usr/bin/env bash
set -euo pipefail

nvim_bin=${NVIM_BIN:-$(command -v nvim)}
sandbox=$(mktemp -d)
trap 'rm -rf "$sandbox"' EXIT

for tool in rg tree-sitter pacman; do
  printf '#!/bin/sh\nexit 0\n' > "$sandbox/$tool"
  chmod +x "$sandbox/$tool"
done
ln -s /bin/sh "$sandbox/sh"
printf '#!/bin/sh\nprintf "%%s\\n" "$*" > "$FD_CAPTURE"\nexit 0\n' > "$sandbox/sudo"
chmod +x "$sandbox/sudo"

FD_CAPTURE="$sandbox/capture" PATH="$sandbox" "$nvim_bin" --headless \
  "+lua vim.ui.select = function(_, _, callback) callback(\"Yes\") end; dofile(vim.fn.stdpath(\"config\") .. \"/lua/config/deps.lua\"); vim.api.nvim_exec_autocmds(\"VimEnter\", {})" \
  '+lua vim.wait(1000)' \
  '+qa' >/dev/null 2>&1

test "$(cat "$sandbox/capture")" = 'pacman -S --needed fd'
