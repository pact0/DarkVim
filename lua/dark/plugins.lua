local core_plugins = {
  -- Packer can manage itself as an optional plugin
  { "wbthomason/packer.nvim" },
  { "neovim/nvim-lspconfig" },
  { "tamago324/nlsp-settings.nvim" },
  {
    "jose-elias-alvarez/null-ls.nvim",
  },
  { "antoinemadec/FixCursorHold.nvim" }, -- Needed while issue https://github.com/neovim/neovim/issues/12587 is still open
  {
    "williamboman/nvim-lsp-installer",
  },
  {
    "darkvim/onedarker.nvim",
    config = function()
      pcall(function()
        if dark and dark.colorscheme == "onedarker" then
          require("onedarker").setup()
          dark.builtin.lualine.options.theme = "onedarker"
        end
      end)
    end,
    disable = dark.colorscheme ~= "onedarker",
  },
  {
    "rcarriga/nvim-notify",
    config = function()
      require("dark.core.notify").setup()
    end,
    requires = { "nvim-telescope/telescope.nvim" },
    disable = not dark.builtin.notify.active or not dark.builtin.telescope.active,
  },
  { "Tastyep/structlog.nvim" },

  { "nvim-lua/popup.nvim" },
  { "nvim-lua/plenary.nvim" },
  -- Telescope
  {
    "nvim-telescope/telescope.nvim",
    config = function()
      require("dark.core.telescope").setup()
    end,
    disable = not dark.builtin.telescope.active,
  },
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    requires = { "nvim-telescope/telescope.nvim" },
    run = "make",
    disable = not dark.builtin.telescope.active,
  },
  -- Install nvim-cmp, and buffer source as a dependency
  {
    "hrsh7th/nvim-cmp",
    config = function()
      if dark.builtin.cmp then
        require("dark.core.cmp").setup()
      end
    end,
    requires = {
      "L3MON4D3/LuaSnip",
    },
  },
  {
    "rafamadriz/friendly-snippets",
    disable = not dark.builtin.luasnip.sources.friendly_snippets,
  },
  {
    "L3MON4D3/LuaSnip",
    config = function()
      local utils = require "dark.utils"
      local paths = {}
      if dark.builtin.luasnip.sources.friendly_snippets then
        paths[#paths + 1] = utils.join_paths(get_runtime_dir(), "site", "pack", "packer", "start", "friendly-snippets")
      end
      local user_snippets = utils.join_paths(get_config_dir(), "snippets")
      if utils.is_directory(user_snippets) then
        paths[#paths + 1] = user_snippets
      end
      require("luasnip.loaders.from_lua").lazy_load()
      require("luasnip.loaders.from_vscode").lazy_load {
        paths = paths,
      }
      require("luasnip.loaders.from_snipmate").lazy_load()
    end,
  },
  {
    "hrsh7th/cmp-nvim-lsp",
  },
  {
    "saadparwaiz1/cmp_luasnip",
  },
  {
    "hrsh7th/cmp-buffer",
  },
  {
    "hrsh7th/cmp-path",
  },
  {
    -- NOTE: Temporary fix till folke comes back
    "max397574/lua-dev.nvim",
    module = "lua-dev",
  },

  -- Autopairs
  {
    "windwp/nvim-autopairs",
    -- event = "InsertEnter",
    config = function()
      require("dark.core.autopairs").setup()
    end,
    disable = not dark.builtin.autopairs.active,
  },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    -- run = ":TSUpdate",
    config = function()
      require("dark.core.treesitter").setup()
    end,
  },
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    event = "BufReadPost",
  },

  -- NvimTree
  {
    "kyazdani42/nvim-tree.lua",
    -- event = "BufWinOpen",
    -- cmd = "NvimTreeToggle",
    config = function()
      require("dark.core.nvimtree").setup()
    end,
    disable = not dark.builtin.nvimtree.active,
  },

  {
    "lewis6991/gitsigns.nvim",

    config = function()
      require("dark.core.gitsigns").setup()
    end,
    event = "BufRead",
    disable = not dark.builtin.gitsigns.active,
  },

  -- Whichkey
  {
    "max397574/which-key.nvim",
    config = function()
      require("dark.core.which-key").setup()
    end,
    event = "BufWinEnter",
    disable = not dark.builtin.which_key.active,
  },

  -- Comments
  {
    "numToStr/Comment.nvim",
    event = "BufRead",
    config = function()
      require("dark.core.comment").setup()
    end,
    disable = not dark.builtin.comment.active,
  },

  -- project.nvim
  {
    "ahmedkhalf/project.nvim",
    config = function()
      require("dark.core.project").setup()
    end,
    disable = not dark.builtin.project.active,
  },

  -- Icons
  {
    "kyazdani42/nvim-web-devicons",
    disable = not dark.use_icons,
  },

  -- Status Line and Bufferline
  {
    -- "hoob3rt/lualine.nvim",
    "nvim-lualine/lualine.nvim",
    -- "Darkvim/lualine.nvim",
    config = function()
      require("dark.core.lualine").setup()
    end,
    disable = not dark.builtin.lualine.active,
  },

  {
    "akinsho/bufferline.nvim",
    config = function()
      require("dark.core.bufferline").setup()
    end,
    branch = "main",
    event = "BufWinEnter",
    disable = not dark.builtin.bufferline.active,
  },

  -- Debugging
  {
    "mfussenegger/nvim-dap",
    -- event = "BufWinEnter",
    config = function()
      require("dark.core.dap").setup()
    end,
    disable = not dark.builtin.dap.active,
  },

  -- Debugger management
  {
    "Pocco81/dap-buddy.nvim",
    branch = "dev",
    -- event = "BufWinEnter",
    -- event = "BufRead",
    disable = not dark.builtin.dap.active,
  },

  -- alpha
  {
    "goolord/alpha-nvim",
    config = function()
      require("dark.core.alpha").setup()
    end,
    disable = not dark.builtin.alpha.active,
  },

  -- Terminal
  {
    "akinsho/toggleterm.nvim",
    event = "BufWinEnter",
    branch = "main",
    config = function()
      require("dark.core.terminal").setup()
    end,
    disable = not dark.builtin.terminal.active,
  },

  -- SchemaStore
  {
    "b0o/schemastore.nvim",
  },
}

local default_snapshot_path = join_paths(get_dark_base_dir(), "snapshots", "default.json")
local content = vim.fn.readfile(default_snapshot_path)
local default_sha1 = vim.fn.json_decode(content)

local get_default_sha1 = function(spec)
  local short_name, _ = require("packer.util").get_plugin_short_name(spec)
  return default_sha1[short_name] and default_sha1[short_name].commit
end

for _, spec in ipairs(core_plugins) do
  if not vim.env.DARK_DEV_MODE then
    -- Manually lock the commit hash since Packer's snapshots are unreliable in headless mode
    spec["commit"] = get_default_sha1(spec)
  end
end

return core_plugins
