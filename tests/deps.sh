#!/usr/bin/env bash
set -euo pipefail

nvim_bin=${NVIM_BIN:-$(command -v nvim)}
config_root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
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

nvim_deps() {
  PATH="$sandbox" "$nvim_bin" --clean --headless --cmd "set rtp^=$config_root" \
    '+lua require("config.deps")' "$@" '+qa'
}

nvim_deps \
  '+NvimDeps' \
  '+lua local messages = vim.fn.execute("messages"); assert(messages:find("sudo pacman %-S %-%-needed fd"))' \
  >/dev/null 2>&1

rm "$sandbox/curl"
nvim_deps \
  '+NvimDeps' \
  '+lua local messages = vim.fn.execute("messages"); assert(messages:find("curl", 1, true))' \
  >/dev/null 2>&1
printf '#!/bin/sh\nexit 0\n' > "$sandbox/curl"
chmod +x "$sandbox/curl"

TREE_SITTER_VERSION=0.26.0 nvim_deps \
  '+NvimDeps' \
  '+lua local messages = vim.fn.execute("messages"); assert(messages:find("tree%-sitter%-cli 0%.26%.1 or later"))' \
  >/dev/null 2>&1

TREE_SITTER_EXIT=127 nvim_deps \
  '+NvimDeps' \
  '+lua local messages = vim.fn.execute("messages"); assert(messages:find("tree%-sitter%-cli 0%.26%.1 or later"))' \
  >/dev/null 2>&1

nvim_deps \
  '+lua vim.version = function() return { major = 0, minor = 11, patch = 0 } end' \
  '+NvimDeps' \
  '+lua local messages = vim.fn.execute("messages"); assert(messages:find("Neovim 0%.12%.0 or later"))' \
  >/dev/null 2>&1
