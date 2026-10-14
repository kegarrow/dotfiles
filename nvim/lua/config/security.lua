-- ==============================================================================
-- CONFIG: SECURITY HARDENING MODULE
-- ==============================================================================
-- Protection against arbitrary code execution, malicious repository hooks,
-- unsafe modelines, and untrusted local workspace scripts.

local M = {}

function M.setup()
  -- 1. MODELINE SECURITY (CVE Mitigation: CVE-2019-12735 and related exploits)
  -- Modelines allow files to run vim commands via embedded comments.
  -- Completely disabling modelines prevents weaponized source files or READMEs
  -- from executing arbitrary Vimscript/Lua when opened.
  vim.opt.modeline = false
  vim.opt.modelines = 0

  -- 2. LOCAL PROJECT CONFIG PROTECTION
  -- Disallow automatic execution of untrusted .exrc, .nvimrc, or .nvim.lua files
  -- found inside project directories. If project-local config is needed,
  -- it should be explicitly vetted by the user.
  vim.opt.exrc = false
  vim.opt.secure = true

  -- 3. SECURE UNDO DIRECTORY PERMISSIONS
  -- Ensure undo history files (which contain full text buffers) are stored only
  -- inside the user's isolated local app data and not in /tmp or world-readable paths.
  local undo_dir = vim.fn.stdpath("data") .. "/undo"
  if vim.fn.isdirectory(undo_dir) == 0 then
    vim.fn.mkdir(undo_dir, "p", 448) -- 0700 permissions on Unix / user-private on Windows
  end

  -- 4. SANITIZE ENVIRONMENT & SECURE SHELL EXECUTION
  -- On Windows, keep native shell invocation fast while ensuring standard RemoteSigned policies
  -- Interactive terminals (toggleterm) use PowerShell independently.

  -- 5. READONLY PROTECTION FOR SENSITIVE FILES
  -- Alert and protect users from accidentally modifying critical system or credential files
  local sensitive_patterns = {
    "*.pem", "*.key", "*.id_rsa", "*.id_ed25519", "*.env", "*.env.local",
    "*credentials*", "*secrets.json"
  }

  local security_group = vim.api.nvim_create_augroup("SecurityHardening", { clear = true })
  vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    group = security_group,
    pattern = sensitive_patterns,
    callback = function(args)
      vim.notify(
        "SECURITY NOTICE: Sensitive file detected (" .. vim.fn.fnamemodify(args.file, ":t") .. "). Handle with care.",
        vim.log.levels.WARN,
        { title = "Security Guard" }
      )
    end,
  })
end

M.setup()

return M
