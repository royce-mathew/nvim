local deps = {
  {
    name = "ripgrep",
    executables = { "rg" },
    install = {
      winget = "winget install -e --id BurntSushi.ripgrep.MSVC",
      brew = "brew install ripgrep",
      pacman = "sudo pacman -S --needed ripgrep",
      apt = "sudo apt update && sudo apt install ripgrep",
      dnf = "sudo dnf install ripgrep",
      apk = "sudo apk add ripgrep",
    },
  },
  {
    name = "fd",
    executables = { "fd", "fdfind" },
    install = {
      winget = "winget install -e --id sharkdp.fd",
      brew = "brew install fd",
      pacman = "sudo pacman -S --needed fd",
      apt = "sudo apt install fd-find",
      dnf = "sudo dnf install fd-find",
      apk = "sudo apk add fd",
    },
  },
  {
    name = "tree-sitter-cli",
    executables = { "tree-sitter" },
    install = {
      winget = "winget install tree-sitter.tree-sitter-cli",
      brew = "brew install tree-sitter-cli",
      pacman = "sudo pacman -S --needed tree-sitter-cli",
      apt = "sudo apt install tree-sitter-cli",
      dnf = "sudo dnf install tree-sitter-cli",
      apk = "sudo apk add tree-sitter",
    },
  },
}

local function package_manager()
  if vim.fn.has("win32") == 1 then
    return vim.fn.executable("winget") == 1 and "winget" or nil
  end
  if vim.fn.has("mac") == 1 then
    return vim.fn.executable("brew") == 1 and "brew" or nil
  end

  for _, manager in ipairs({ "pacman", "apt", "dnf", "apk" }) do
    local executable = manager == "apt" and "apt-get" or manager
    if vim.fn.executable(executable) == 1 then
      return manager
    end
  end
end

local function missing_dependencies()
  local missing = {}

  for _, dep in ipairs(deps) do
    local found = false
    for _, executable in ipairs(dep.executables) do
      if vim.fn.executable(executable) == 1 then
        found = true
        break
      end
    end
    if not found then
      table.insert(missing, dep)
    end
  end

  return missing
end

local function dependency_names(dependencies)
  local names = {}
  for _, dep in ipairs(dependencies) do
    table.insert(names, dep.name)
  end
  return table.concat(names, ", ")
end

local function installation_message(missing)
  local manager = package_manager()
  if not manager then
    return "Missing dependencies: " .. dependency_names(missing) .. ". Install them with your system package manager."
  end

  local commands = {}
  for _, dep in ipairs(missing) do
    local command = dep.install[manager]
    if command then
      table.insert(commands, command)
    else
      table.insert(commands, "# Install " .. dep.name .. " with " .. manager)
    end
  end

  return "Missing dependencies: " .. dependency_names(missing) .. ".\nRun these commands:\n" .. table.concat(commands, "\n")
end

local function show_installation_instructions()
  local missing = missing_dependencies()
  if #missing == 0 then
    vim.notify("All external Neovim dependencies are installed.", vim.log.levels.INFO)
    return
  end

  vim.notify(installation_message(missing), vim.log.levels.WARN)
end

vim.api.nvim_create_user_command("NvimDeps", show_installation_instructions, {
  desc = "Show external Neovim dependency installation commands",
})

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    local missing = missing_dependencies()
    if #missing > 0 then
      vim.schedule(function()
        vim.notify(
          "Missing dependencies: " .. dependency_names(missing) .. ". Run :NvimDeps for installation commands.",
          vim.log.levels.WARN
        )
      end)
    end
  end,
  once = true,
})
