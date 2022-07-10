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

  { "tpope/vim-repeat" },

  -- {
  --   "ray-x/lsp_signature.nvim",
  --   event = "BufRead",
  --   config = function() require "lsp_signature".on_attach() end,
  -- },

  {
    "LunarVim/onedarker.nvim",
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

  --{
  --  "nvim-telescope/telescope-fzy-native.nvim",
  --  run = "make",
  --  event = "BufRead",
  --},

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

      -- paths[#paths + 1] = utils.join_paths(get_runtime_dir(), "dark", "snippets")
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

  {
    "windwp/nvim-spectre",
    event = "BufRead",
    config = function()
      require("spectre").setup()
    end,
  },

  {
    "folke/trouble.nvim",
    requires = { "kyazdani42/nvim-web-devicons", "nvim-telescope/telescope.nvim" },
    config = function()
      require("trouble").setup {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      }
    end
  },

  {
    "folke/todo-comments.nvim",
    requires = "kyazdani42/nvim-web-devicons",
    config = function()
      require("todo-comments").setup {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      }
    end
  },

  {
    "gbprod/cutlass.nvim",
    config = function()
      require("cutlass").setup({
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      })
    end
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    event = "BufRead",
    opt = true,
    config = function()
      require("indent_blankline").setup({
        enabled = true,
        -- char = "|",
        char_list = { "", "┊", "┆", "¦", "|", "¦", "┆", "┊", "" },
        filetype_exclude = {
          "help", "startify", "dashboard", "packer", "guihua", "NvimTree",
          "sidekick", "alpha"
        },
        show_trailing_blankline_indent = false,
        show_first_indent_level = false,
        buftype_exclude = { "terminal", "dashboard" },
        space_char_blankline = " ",
        use_treesitter = true,
        show_current_context = true,
        show_current_context_start = true,
        context_patterns = {
          "class", "return", "function", "method", "^if", "if", "^while",
          "jsx_element", "^for", "for", "^object", "^table", "block",
          "arguments", "if_statement", "else_clause", "jsx_element",
          "jsx_self_closing_element", "try_statement", "catch_clause",
          "import_statement", "operation_type"
        },
        bufname_exclude = { "README.md" }
      })
      -- useing treesitter instead of char highlight
      -- vim.g.indent_blankline_char_highlight_list =
      -- {"WarningMsg", "Identifier", "Delimiter", "Type", "String", "Boolean"}
    end
  },

  -- Motions

  -- ga selection
  {
    "junegunn/vim-easy-align",
    opt = true,
    cmd = "EasyAlign"
  },

  { "chaoren/vim-wordmotion",
    config = function()
      vim.g.wordmotion_nomap = 0
      vim.cmd [[nmap w <Plug>WordMotion_w]]
      vim.cmd [[nmap b <Plug>WordMotion_b]]
      vim.cmd [[let g:wordmotion_mappings = {
              \ 'ge' : 'g<M-e>',
              \ 'aw' : 'a<M-w>',
              \ 'iw' : 'i<M-w>',
              \ '<C-R><C-W>' : '<C-R><M-w>'
              \ }]]
    end
  },

  -- sa<object><new_surr>
  -- sd<object><surr>
  -- sr<object><curr_surr><new_surr>
  {
    "machakann/vim-sandwich",
    opt = true,
    event = "CursorMoved"
  },

  -- {
  --   "monaqa/dial.nvim",
  --   event = "BufRead",
  --   opt = true,
  --   keys = { "<C-a>", "<C-x>" },
  --   config = function()
  --     local dial = require("dial")
  --     vim.cmd [[
  --     nmap <C-a> <Plug>(dial-increment)
  --     nmap <C-x> <Plug>(dial-decrement)
  --     vmap <C-a> <Plug>(dial-increment)
  --     vmap <C-x> <Plug>(dial-decrement)
  --     vmap g<C-a> <Plug>(dial-increment-additional)
  --     vmap g<C-x> <Plug>(dial-decrement-additional)
  --   ]]
  --     table.insert(dial.config.searchlist.normal, {
  --       "number#decimal", "number#hex", "number#binary", "date#[%Y/%m/%d]",
  --       "markup#markdown#header", 'date#[%Y-%m-%d]', 'date#[%H:%M:%S]',
  --       'date#[%H:%M]'
  --     })

  --     dial.augends["custom#boolean"] = dial.common.enum_cyclic {
  --       name = "boolean",
  --       strlist = { "true", "false" },
  --     }
  --     table.insert(dial.config.searchlist.normal, "custom#boolean")


  --     -- For Languages which prefer True/False, e.g. python.
  --     dial.augends["custom#Boolean"] = dial.common.enum_cyclic {
  --       name = "Boolean",
  --       strlist = { "True", "False" },
  --     }
  --     table.insert(dial.config.searchlist.normal, "custom#Boolean")
  --   end,
  -- },

  {
    'sQVe/sort.nvim',
    opt = true,
    cmd = "Sort",
    config = function()
      require("sort").setup({
        -- Input configuration here.
        -- Refer to the configuration section below for options.
      })
    end
  },

  -- Project
  {
    "ethanholz/nvim-lastplace",
    event = "BufRead",
    config = function()
      require("nvim-lastplace").setup({
        lastplace_ignore_buftype = { "quickfix", "nofile", "help" },
        lastplace_ignore_filetype = {
          "gitcommit", "gitrebase", "svn", "hgcommit",
        },
        lastplace_open_folds = true,
      })
    end,
  },

  -- project.nvim
  {
    "ahmedkhalf/project.nvim",
    config = function()
      require("dark.core.project").setup()
    end,
    disable = not dark.builtin.project.active,
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

  {
    "andymass/vim-matchup",
    disable = not dark.use_matchup,
    opt = true,
    event = { "CursorMoved", "CursorMovedI" },
    cmd = { 'MatchupWhereAmI?' },
    config = function()
      vim.g.matchup_enabled = 1
      vim.g.matchup_surround_enabled = 1
      -- vim.g.matchup_transmute_enabled = 1
      vim.g.matchup_matchparen_deferred = 1
      vim.g.matchup_matchparen_offscreen = { method = 'popup' }
    end
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

  {
    "windwp/nvim-ts-autotag",
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  },

  {
    "RRethy/nvim-treesitter-endwise",
    event = "BufReadPost",
  },

  {
    "romgrk/nvim-treesitter-context",
    config = function()
      require("treesitter-context").setup {
        enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
        throttle = true, -- Throttles plugin updates (may improve performance)
        max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
        patterns = { -- Match patterns for TS nodes. These get wrapped to match at word boundaries.
          -- For all filetypes
          -- Note that setting an entry here replaces all other patterns for this entry.
          -- By setting the 'default' entry below, you can control which nodes you want to
          -- appear in the context window.
          default = {
            'class',
            'function',
            'method',
          },
        },
      }
    end
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

  -- Git
  {
    "lewis6991/gitsigns.nvim",

    config = function()
      require("dark.core.gitsigns").setup()
    end,
    event = "BufRead",
    disable = not dark.builtin.gitsigns.active,
  },

  {
    "tpope/vim-fugitive",
    cmd = {
      "G",
      "Git",
      "Gdiffsplit",
      "Gread",
      "Gwrite",
      "Ggrep",
      "GMove",
      "GDelete",
      "GBrowse",
      "GRemove",
      "GRename",
      "Glgrep",
      "Gedit"
    },
    ft = { "fugitive" }
  },

  {
    "sindrets/diffview.nvim",
    event = "BufRead",
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
