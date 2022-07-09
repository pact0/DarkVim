local a = require "plenary.async_lib.tests"
local uv = vim.loop
local home_dir = uv.os_homedir()

a.describe("initial start", function()
  local dark_config_path = get_config_dir()
  local dark_runtime_path = get_runtime_dir()
  local dark_cache_path = get_cache_dir()

  a.it("should be able to detect test environment", function()
    assert.truthy(os.getenv "DARK_TEST_ENV")
    assert.falsy(package.loaded["dark.impatient"])
  end)

  a.it("should be able to use darkvim cache directory using vim.fn", function()
    assert.equal(dark_cache_path, vim.fn.stdpath "cache")
  end)

  a.it("should be to retrieve default neovim directories", function()
    local xdg_config = os.getenv "XDG_CONFIG_HOME" or join_paths(home_dir, ".config")
    assert.equal(join_paths(xdg_config, "nvim"), vim.call("stdpath", "config"))
  end)

  a.it("should be able to read darkvim directories", function()
    local rtp_list = vim.opt.rtp:get()
    assert.truthy(vim.tbl_contains(rtp_list, dark_runtime_path .. "/dark"))
    assert.truthy(vim.tbl_contains(rtp_list, dark_config_path))
  end)

  a.it("should be able to run treesitter without errors", function()
    assert.truthy(vim.treesitter.highlighter.active)
  end)

  a.it("should be able to pass basic checkhealth without errors", function()
    vim.cmd "set cmdheight&"
    vim.cmd "checkhealth nvim"
    local errmsg = vim.fn.eval "v:errmsg"
    local exception = vim.fn.eval "v:exception"
    assert.equal("", errmsg) -- v:errmsg was not updated.
    assert.equal("", exception)
  end)
end)
