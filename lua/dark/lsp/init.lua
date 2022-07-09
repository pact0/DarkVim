local M = {}
local Log = require "dark.core.log"
local utils = require "dark.utils"
local autocmds = require "dark.core.autocmds"

local function add_lsp_buffer_keybindings(bufnr)
  local mappings = {
    normal_mode = "n",
    insert_mode = "i",
    visual_mode = "v",
  }

  for mode_name, mode_char in pairs(mappings) do
    for key, remap in pairs(dark.lsp.buffer_mappings[mode_name]) do
      local opts = { buffer = bufnr, desc = remap[2], noremap = true, silent = true }
      vim.keymap.set(mode_char, key, remap[1], opts)
    end
  end
end

function M.common_capabilities()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = {
      "documentation",
      "detail",
      "additionalTextEdits",
    },
  }

  local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
  if status_ok then
    capabilities = cmp_nvim_lsp.update_capabilities(capabilities)
  end

  return capabilities
end

function M.common_on_exit(_, _)
  if dark.lsp.document_highlight then
    autocmds.clear_augroup "lsp_document_highlight"
  end
  if dark.lsp.code_lens_refresh then
    autocmds.clear_augroup "lsp_code_lens_refresh"
  end
end

function M.common_on_init(client, bufnr)
  if dark.lsp.on_init_callback then
    dark.lsp.on_init_callback(client, bufnr)
    Log:debug "Called lsp.on_init_callback"
    return
  end
end

function M.common_on_attach(client, bufnr)
  if dark.lsp.on_attach_callback then
    dark.lsp.on_attach_callback(client, bufnr)
    Log:debug "Called lsp.on_attach_callback"
  end
  local lu = require "dark.lsp.utils"
  if dark.lsp.document_highlight then
    lu.setup_document_highlight(client, bufnr)
  end
  if dark.lsp.code_lens_refresh then
    lu.setup_codelens_refresh(client, bufnr)
  end
  add_lsp_buffer_keybindings(bufnr)
end

function M.get_common_opts()
  return {
    on_attach = M.common_on_attach,
    on_init = M.common_on_init,
    on_exit = M.common_on_exit,
    capabilities = M.common_capabilities(),
  }
end

function M.setup()
  Log:debug "Setting up LSP support"

  local lsp_status_ok, _ = pcall(require, "lspconfig")
  if not lsp_status_ok then
    return
  end

  if dark.use_icons then
    for _, sign in ipairs(dark.lsp.diagnostics.signs.values) do
      vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = sign.name })
    end
  end

  require("dark.lsp.handlers").setup()

  if not utils.is_directory(dark.lsp.templates_dir) then
    require("dark.lsp.templates").generate_templates()
  end

  pcall(function()
    require("nlspsettings").setup(dark.lsp.nlsp_settings.setup)
  end)

  pcall(function()
    require("nvim-lsp-installer").setup(dark.lsp.installer.setup)
  end)

  require("dark.lsp.null-ls").setup()

  autocmds.configure_format_on_save()
end

return M
