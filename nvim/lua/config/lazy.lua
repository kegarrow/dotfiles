-- ==============================================================================
-- CONFIG: LAZY.NVIM BOOTSTRAP & PLUGIN MANAGER SETUP
-- ==============================================================================
-- Secure bootstrap using official HTTPS Git repository and deterministic lockfile.

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    lazyrepo,
    lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Configure lazy.nvim with security hardening and performance tuning
require("lazy").setup({
  spec = {
    { import = "plugins" },
  },
  defaults = {
    lazy = false, -- Load plugins eagerly by default unless overridden
    version = false, -- Always use default branches unless pinned
  },
  lockfile = vim.fn.stdpath("config") .. "/lazy-lock.json",
  install = {
    -- Pin colorscheme during installation
    colorscheme = { "tokyonight", "catppuccin", "habamax" },
    missing = true,
  },
  rocks = {
    enabled = false,
    hererocks = false,
  },
  checker = {
    -- Security & Stability: Disable silent background updates to prevent breaking changes or supply chain drifts
    enabled = false,
    notify = false,
  },
  change_detection = {
    enabled = true,
    notify = false,
  },
  concurrency = 8, -- Safe network and CPU worker pool limit
  git = {
    -- Enforce HTTPS protocol for all plugin downloads
    url_format = "https://github.com/%s.git",
    timeout = 120,
  },
  ui = {
    size = { width = 0.85, height = 0.85 },
    border = "rounded",
    icons = {
      cmd = " ",
      config = "",
      event = " ",
      ft = " ",
      init = " ",
      import = " ",
      keys = " ",
      lazy = "󰒲 ",
      loaded = "●",
      not_loaded = "○",
      plugin = " ",
      runtime = " ",
      require = "󰢱 ",
      source = " ",
      start = " ",
      task = "✔ ",
      list = {
        "●",
        "➜",
        "★",
        "‒",
      },
    },
  },
  performance = {
    rtp = {
      -- Disable built-in Vim plugins that are superseded by modern Lua plugins
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
