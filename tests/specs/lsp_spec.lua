local a = require "plenary.async_lib.tests"
local utils = require "dark.utils"
local helpers = require "tests.dark.helpers"
local spy = require "luassert.spy"

a.describe("lsp workflow", function()
  before_each(function()
    vim.cmd [[
     let v:errmsg = ""
      let v:errors = []
    ]]
  end)

  after_each(function()
    local errmsg = vim.fn.eval "v:errmsg"
    local exception = vim.fn.eval "v:exception"
    local errors = vim.fn.eval "v:errors"
    assert.equal("", errmsg)
    assert.equal("", exception)
    assert.True(vim.tbl_isempty(errors))
  end)

  dark.lsp.templates_dir = join_paths(get_cache_dir(), "artifacts")

  a.it("should be able to delete ftplugin templates", function()
    if utils.is_directory(dark.lsp.templates_dir) then
      assert.equal(vim.fn.delete(dark.lsp.templates_dir, "rf"), 0)
    end
    assert.False(utils.is_directory(dark.lsp.templates_dir))
  end)

  a.it("should be able to generate ftplugin templates", function()
    if utils.is_directory(dark.lsp.templates_dir) then
      assert.equal(vim.fn.delete(dark.lsp.templates_dir, "rf"), 0)
    end

    require("dark.lsp").setup()

    assert.True(utils.is_directory(dark.lsp.templates_dir))
  end)

  a.it("should not include blacklisted servers in the generated templates", function()
    require("dark.lsp").setup()

    for _, file in ipairs(vim.fn.glob(dark.lsp.templates_dir .. "/*.lua", 1, 1)) do
      for _, server_name in ipairs(dark.lsp.override) do
        local setup_cmd = string.format([[require("dark.lsp.manager").setup(%q)]], server_name)
        assert.False(helpers.file_contains(file, setup_cmd))
      end
    end
  end)

  a.it("should only include one server per generated template", function()
    require("dark.lsp").setup()

    for _, file in ipairs(vim.fn.glob(dark.lsp.templates_dir .. "/*.lua", 1, 1)) do
      local content = {}
      for entry in io.lines(file) do
        table.insert(content, entry)
      end
      local err_msg = ""
      if #content > 1 then
        err_msg = string.format(
          "found more than one server for [%q]: \n{\n %q \n}",
          file:match "[^/]*.lua$",
          table.concat(content, ", ")
        )
      end
      assert.equal(err_msg, "")
    end
  end)

  a.it("should not attempt to re-generate ftplugin templates", function()
    local s = spy.on(require "dark.lsp.templates", "generate_templates")
    local plugins = require "dark.plugins"
    require("dark.plugin-loader").load { plugins, dark.plugins }

    require("dark.lsp").setup()
    assert.spy(s).was_not_called()
    s:revert()
  end)
end)
