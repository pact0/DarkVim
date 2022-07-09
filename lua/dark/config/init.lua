local utils = require "dark.utils"
local Log = require "dark.core.log"

local M = {}
local user_config_dir = get_config_dir()
local user_config_file = utils.join_paths(user_config_dir, "config.lua")

---Get the full path to the user configuration file
---@return string
function M:get_user_config_path()
  return user_config_file
end

--- Initialize dark default configuration and variables
function M:init()
  dark = vim.deepcopy(require "dark.config.defaults")

  require("dark.keymappings").load_defaults()

  local builtins = require "dark.core.builtins"
  builtins.config { user_config_file = user_config_file }

  local settings = require "dark.config.settings"
  settings.load_defaults()

  local autocmds = require "dark.core.autocmds"
  autocmds.load_defaults()

  local dark_lsp_config = require "dark.lsp.config"
  dark.lsp = vim.deepcopy(dark_lsp_config)

  ---@deprecated replaced with dark.builtin.alpha
  dark.builtin.dashboard = {
    active = false,
    on_config_done = nil,
    search_handler = "",
    disable_at_vim_enter = 0,
    session_directory = "",
    custom_header = {},
    custom_section = {},
    footer = {},
  }

  dark.builtin.luasnip = {
    sources = {
      friendly_snippets = true,
    },
  }
end

local function handle_deprecated_settings()
  local function deprecation_notice(setting, new_setting)
    local in_headless = #vim.api.nvim_list_uis() == 0
    if in_headless then
      return
    end

    local msg = string.format(
      "Deprecation notice: [%s] setting is no longer supported. %s",
      setting,
      new_setting or "See https://github.com/DarkVim/DarkVim#breaking-changes"
    )
    vim.schedule(function()
      vim.notify_once(msg, vim.log.levels.WARN)
    end)
  end

  ---dark.lang.FOO.lsp
  for lang, entry in pairs(dark.lang) do
    local deprecated_config = entry.formatters or entry.linters or {}
    if not vim.tbl_isempty(deprecated_config) then
      deprecation_notice(string.format("dark.lang.%s", lang))
    end
  end

  -- dark.lsp.override
  if dark.lsp.override and not vim.tbl_isempty(dark.lsp.override) then
    deprecation_notice("dark.lsp.override", "Use `dark.lsp.automatic_configuration.skipped_servers` instead")
    vim.tbl_map(function(c)
      if not vim.tbl_contains(dark.lsp.automatic_configuration.skipped_servers, c) then
        table.insert(dark.lsp.automatic_configuration.skipped_servers, c)
      end
    end, dark.lsp.override)
  end

  -- dark.lsp.popup_border
  if vim.tbl_contains(vim.tbl_keys(dark.lsp), "popup_border") then
    deprecation_notice "dark.lsp.popup_border"
  end

  -- dashboard.nvim
  if dark.builtin.dashboard.active then
    deprecation_notice("dark.builtin.dashboard", "Use `dark.builtin.alpha` instead. See DarkVim#1906")
  end

  if dark.autocommands.custom_groups then
    deprecation_notice(
      "dark.autocommands.custom_groups",
      "Use vim.api.nvim_create_autocmd instead or check DarkVim#2592 to learn about the new syntax"
    )
  end
end

--- Override the configuration with a user provided one
-- @param config_path The path to the configuration overrides
function M:load(config_path)
  local autocmds = require "dark.core.autocmds"
  config_path = config_path or self:get_user_config_path()
  local ok, err = pcall(dofile, config_path)
  if not ok then
    if utils.is_file(user_config_file) then
      Log:warn("Invalid configuration: " .. err)
    else
      vim.notify_once(string.format("Unable to find configuration file [%s]", config_path), vim.log.levels.WARN)
    end
  end

  handle_deprecated_settings()

  autocmds.define_autocmds(dark.autocommands)

  vim.g.mapleader = (dark.leader == "space" and " ") or dark.leader

  require("dark.keymappings").load(dark.keys)

  if dark.transparent_window then
    autocmds.enable_transparent_mode()
  end
end

--- Override the configuration with a user provided one
-- @param config_path The path to the configuration overrides
function M:reload()
  vim.schedule(function()
    require_clean("dark.utils.hooks").run_pre_reload()

    M:load()

    require("dark.core.autocmds").configure_format_on_save()

    local plugins = require "dark.plugins"
    local plugin_loader = require "dark.plugin-loader"

    plugin_loader.reload { plugins, dark.plugins }
    require_clean("dark.utils.hooks").run_post_reload()
  end)
end

return M
