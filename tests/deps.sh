#!/usr/bin/env bash
set -euo pipefail

nvim_bin=${NVIM_BIN:-$(command -v nvim)}
sandbox=$(mktemp -d)
trap 'rm -rf "$sandbox"' EXIT

for tool in rg curl tar cc pacman; do
  printf '#!/bin/sh\nexit 0\n' > "$sandbox/$tool"
  chmod +x "$sandbox/$tool"
done

cat > "$sandbox/tree-sitter" <<'EOF'
#!/bin/sh
if [ "${1:-}" = "--version" ]; then
  printf 'tree-sitter %s\n' "${TREE_SITTER_VERSION:-0.26.1}"
fi
exit "${TREE_SITTER_EXIT:-0}"
EOF
chmod +x "$sandbox/tree-sitter"
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

rm "$sandbox/curl"
PATH="$sandbox" "$nvim_bin" --headless \
  '+NvimDeps' \
  '+lua local messages = vim.fn.execute("messages"); assert(messages:find("curl", 1, true))' \
  '+qa' >/dev/null 2>&1
printf '#!/bin/sh\nexit 0\n' > "$sandbox/curl"
chmod +x "$sandbox/curl"

TREE_SITTER_VERSION=0.26.0 PATH="$sandbox" "$nvim_bin" --headless \
  '+NvimDeps' \
  '+lua local messages = vim.fn.execute("messages"); assert(messages:find("tree%-sitter%-cli 0%.26%.1 or later")); assert(not messages:find("Failed to run config for nvim%-treesitter"))' \
  '+qa' >/dev/null 2>&1

TREE_SITTER_EXIT=127 PATH="$sandbox" "$nvim_bin" --headless \
  '+NvimDeps' \
  '+lua local messages = vim.fn.execute("messages"); assert(messages:find("tree%-sitter%-cli 0%.26%.1 or later"))' \
  '+qa' >/dev/null 2>&1

PATH="$sandbox" "$nvim_bin" --headless \
  '+lua vim.version = function() return { major = 0, minor = 11, patch = 0 } end' \
  '+NvimDeps' \
  '+lua local messages = vim.fn.execute("messages"); assert(messages:find("Neovim 0%.12%.0 or later"))' \
  '+qa' >/dev/null 2>&1
