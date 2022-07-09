local M = {}

vim.cmd [[
  function! QuickFixToggle()
    if empty(filter(getwininfo(), 'v:val.quickfix'))
      copen
    else
      cclose
    endif
  endfunction
]]

M.defaults = {
  {
    name = "BufferKill",
    fn = function()
      require("dark.core.bufferline").buf_kill "bd"
    end,
  },
  {
    name = "DarkToggleFormatOnSave",
    fn = function()
      require("dark.core.autocmds").toggle_format_on_save()
    end,
  },
  {
    name = "DarkInfo",
    fn = function()
      require("dark.core.info").toggle_popup(vim.bo.filetype)
    end,
  },
  {
    name = "DarkCacheReset",
    fn = function()
      require("dark.utils.hooks").reset_cache()
    end,
  },
  {
    name = "DarkReload",
    fn = function()
      require("dark.config"):reload()
    end,
  },
  {
    name = "DarkUpdate",
    fn = function()
      require("dark.bootstrap"):update()
    end,
  },
  {
    name = "DarkSyncCorePlugins",
    fn = function()
      require("dark.plugin-loader").sync_core_plugins()
    end,
  },
  {
    name = "DarkChangelog",
    fn = function()
      require("dark.core.telescope.custom-finders").view_darkvim_changelog()
    end,
  },
  {
    name = "DarkVersion",
    fn = function()
      print(require("dark.utils.git").get_dark_version())
    end,
  },
  {
    name = "DarkOpenlog",
    fn = function()
      vim.fn.execute("edit " .. require("dark.core.log").get_path())
    end,
  },
}

function M.load(collection)
  local common_opts = { force = true }
  for _, cmd in pairs(collection) do
    local opts = vim.tbl_deep_extend("force", common_opts, cmd.opts or {})
    vim.api.nvim_create_user_command(cmd.name, cmd.fn, opts)
  end
end

return M
