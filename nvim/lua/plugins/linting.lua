-- ==============================================================================
-- PLUGINS: ASYNCHRONOUS CODE LINTING (nvim-lint)
-- ==============================================================================

return {
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufWritePost" },
    opts = {
      linters_by_ft = {
        python = { "ruff" },
        javascript = { "eslint_d" },
        typescript = { "eslint_d" },
        javascriptreact = { "eslint_d" },
        typescriptreact = { "eslint_d" },
      },
    },
    config = function(_, opts)
      local lint = require("lint")
      lint.linters_by_ft = opts.linters_by_ft

      local lint_augroup = vim.api.nvim_create_augroup("nvim-lint", { clear = true })
      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
        group = lint_augroup,
        callback = function()
          -- Only attempt linting if linter executable is present on system to prevent spurious errors
          local names = lint.linters_by_ft[vim.bo.filetype] or {}
          local available = {}
          for _, name in ipairs(names) do
            local linter = lint.linters[name]
            local cmd = type(linter) == "table" and linter.cmd or name
            if vim.fn.executable(cmd) == 1 then
              table.insert(available, name)
            end
          end
          if #available > 0 then
            lint.try_lint(available)
          end
        end,
      })

      vim.keymap.set("n", "<leader>cl", function()
        lint.try_lint()
      end, { desc = "Trigger Linting for Current File" })
    end,
  },
}
