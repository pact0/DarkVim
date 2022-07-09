local M = {}

local builtins = {
  "dark.core.which-key",
  "dark.core.gitsigns",
  "dark.core.cmp",
  "dark.core.dap",
  "dark.core.terminal",
  "dark.core.telescope",
  "dark.core.treesitter",
  "dark.core.nvimtree",
  "dark.core.project",
  "dark.core.bufferline",
  "dark.core.autopairs",
  "dark.core.comment",
  "dark.core.notify",
  "dark.core.lualine",
  "dark.core.alpha",
}

function M.config(config)
  for _, builtin_path in ipairs(builtins) do
    local builtin = require(builtin_path)
    builtin.config(config)
  end
end

return M
