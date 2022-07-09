local init_path = debug.getinfo(1, "S").source:sub(2)
local base_dir = init_path:match("(.*[/\\])"):sub(1, -2)

if not vim.tbl_contains(vim.opt.rtp:get(), base_dir) then
  vim.opt.rtp:append(base_dir)
end

require("dark.bootstrap"):init(base_dir)

require("dark.config"):load()

local plugins = require "dark.plugins"
require("dark.plugin-loader").load { plugins, dark.plugins }

local Log = require "dark.core.log"
Log:debug "Starting DarkVim"

local commands = require "dark.core.commands"
commands.load(commands.defaults)

require("dark.lsp").setup()
