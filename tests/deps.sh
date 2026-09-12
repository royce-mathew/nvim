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
for tool in dirname readlink; do
  ln -s "$(command -v "$tool")" "$sandbox/$tool"
done

if fusermount=$(command -v fusermount 2>/dev/null); then
  ln -s "$fusermount" "$sandbox/fusermount"
fi

printf '#!/bin/sh\nprintf "%%s\\n" "$*" > "$FD_CAPTURE"\nexit 0\n' > "$sandbox/sudo"
chmod +x "$sandbox/sudo"

FD_CAPTURE="$sandbox/capture" PATH="$sandbox" "$nvim_bin" --headless \
  '+NvimDeps' \
  '+lua local messages = vim.fn.execute("messages"); assert(messages:find("sudo pacman %-S %-%-needed fd"))' \
  '+qa' >/dev/null 2>&1

test ! -e "$sandbox/capture"
