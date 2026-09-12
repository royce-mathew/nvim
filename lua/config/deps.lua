local deps = {
  {
    name = "ripgrep",
    cmd = "rg",
    install = {
      win32 = "winget install -e --id BurntSushi.ripgrep.MSVC",
      mac = "brew install ripgrep",
      arch = "sudo pacman -S --needed ripgrep",
      unix = "sudo apt update && sudo apt install ripgrep",
    },
  },
  {
    name = "fd",
    cmd = { "fd", "fdfind" },
    install = {
      win32 = "winget install -e --id sharkdp.fd",
      mac = "brew install fd",
      arch = "sudo pacman -S --needed fd",
      unix = "sudo apt install fd-find",
    },
  },
  {
    name = "tree-sitter-cli",
    cmd = "tree-sitter",
    install = {
      win32 = "winget install tree-sitter.tree-sitter-cli",
      mac = "brew install tree-sitter-cli",
      arch = "sudo pacman -S --needed tree-sitter-cli",
      unix = "sudo apt install tree-sitter-cli",
    },
  },
}

local function get_os()
  if vim.fn.has("win32") == 1 then
    return "win32"
  elseif vim.fn.has("mac") == 1 then
    return "mac"
  elseif vim.fn.executable("pacman") == 1 then
    return "arch"
  else
    return "unix"
  end
end

local function check_and_install_deps()
  local missing = {}
  local current_os = get_os()

  for _, dep in ipairs(deps) do
    local commands = type(dep.cmd) == "table" and dep.cmd or { dep.cmd }
    local found = false
    for _, cmd in ipairs(commands) do
      if vim.fn.executable(cmd) == 1 then
        found = true
        break
      end
    end
    if not found then
      table.insert(missing, dep)
    end
  end

  if #missing == 0 then return end

  -- Build missing names string
  local missing_names = {}
  for _, dep in ipairs(missing) do
    table.insert(missing_names, dep.name)
  end

  local msg = "Missing dependencies: " .. table.concat(missing_names, ", ") .. ". Install them now?"

  vim.schedule(function()
    vim.ui.select({"Yes", "No"}, { prompt = msg }, function(choice)
      if choice == "Yes" then
        local install_cmds = {}

        -- Collect install commands for the missing dependencies
        for _, dep in ipairs(missing) do
          local cmd = dep.install[current_os]
          if cmd then
            table.insert(install_cmds, cmd)
          end
        end

        if #install_cmds > 0 then
          -- Join commands with && to run them sequentially
          local full_cmd = table.concat(install_cmds, " && ")
          vim.cmd("split | term " .. full_cmd)
          vim.notify("Installing dependencies... Please wait and close the terminal when done.", vim.log.levels.INFO)
        end
      end
    end)
  end)
end

vim.api.nvim_create_autocmd("VimEnter", {
  callback = check_and_install_deps,
  once = true,
})
