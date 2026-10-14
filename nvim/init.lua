-- ==============================================================================
-- NVIM CONFIGURATION - FULL BLOWN MODERN IDE ENTRYPOINT
-- ==============================================================================
-- Leader key MUST be set before plugins or mappings are loaded!
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Set UTF-8 encoding
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"

-- Load core configuration modules
require("config.options")
require("config.security")
require("config.keymaps")
require("config.autocmds")

-- Bootstrap & load lazy.nvim plugin ecosystem
require("config.lazy")
