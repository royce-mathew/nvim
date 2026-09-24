local M = {}

local minimum_neovim_version = { 0, 12, 0 }
local minimum_tree_sitter_version = { 0, 26, 1 }

local function version_at_least(version, minimum)
  for index, required in ipairs(minimum) do
    if version[index] ~= required then
      return version[index] > required
    end
  end

  return true
end

local function neovim_version()
  local version = vim.version()
  return { version.major, version.minor, version.patch }
end

local function tree_sitter_version()
  if vim.fn.executable("tree-sitter") ~= 1 then
    return nil
  end

  local output = vim.fn.system({ "tree-sitter", "--version" })
  if vim.v.shell_error ~= 0 then
    return nil
  end

  local major, minor, patch = output:match("tree%-sitter%s+(%d+)%.(%d+)%.(%d+)")
  if not major then
    return nil
  end

  return { tonumber(major), tonumber(minor), tonumber(patch) }
end

local deps = {
  {
    name = "Neovim 0.12.0 or later",
    treesitter = true,
    validate = function()
      return version_at_least(neovim_version(), minimum_neovim_version)
    end,
  },
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
    name = "curl",
    executables = { "curl" },
    treesitter = true,
    install = {
      winget = "winget install -e --id curl.curl",
      brew = "brew install curl",
      pacman = "sudo pacman -S --needed curl",
      apt = "sudo apt install curl",
      dnf = "sudo dnf install curl",
      apk = "sudo apk add curl",
    },
  },
  {
    name = "tar",
    executables = { "tar" },
    treesitter = true,
    install = {
      brew = "brew install gnu-tar",
      pacman = "sudo pacman -S --needed tar",
      apt = "sudo apt install tar",
      dnf = "sudo dnf install tar",
      apk = "sudo apk add tar",
    },
  },
  {
    name = "C compiler",
    executables = { "cc", "gcc", "clang", "cl" },
    treesitter = true,
    install = {
      winget = "winget install -e --id LLVM.LLVM",
      brew = "brew install llvm",
      pacman = "sudo pacman -S --needed base-devel",
      apt = "sudo apt install build-essential",
      dnf = "sudo dnf install gcc",
      apk = "sudo apk add build-base",
    },
  },
  {
    name = "tree-sitter-cli 0.26.1 or later",
    executables = { "tree-sitter" },
    treesitter = true,
    validate = function()
      local version = tree_sitter_version()
      return version and version_at_least(version, minimum_tree_sitter_version)
    end,
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

local function dependency_is_available(dep)
  if dep.validate then
    return dep.validate()
  end

  for _, executable in ipairs(dep.executables) do
    if vim.fn.executable(executable) == 1 then
      return true
    end
  end

  return false
end

local function missing_dependencies(treesitter_only)
  local missing = {}

  for _, dep in ipairs(deps) do
    if (not treesitter_only or dep.treesitter) and not dependency_is_available(dep) then
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
    local command = dep.install and dep.install[manager]
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

function M.treesitter_plugin_ready()
  return version_at_least(neovim_version(), minimum_neovim_version)
end

function M.treesitter_installer_ready()
  return #missing_dependencies(true) == 0
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

return M
