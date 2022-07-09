-- Set Default Prefix.
-- Note: You can set a prefix per lsp server in the lv-globals.lua file
local M = {}

function M.setup()
  local config = { -- your config
    virtual_text = dark.lsp.diagnostics.virtual_text,
    signs = dark.lsp.diagnostics.signs,
    underline = dark.lsp.diagnostics.underline,
    update_in_insert = dark.lsp.diagnostics.update_in_insert,
    severity_sort = dark.lsp.diagnostics.severity_sort,
    float = dark.lsp.diagnostics.float,
  }
  vim.diagnostic.config(config)
  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, dark.lsp.float)
  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, dark.lsp.float)
end

return M
