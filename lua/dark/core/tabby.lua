local M = {}


M.setup = function()
  require("tabby").setup({
    tabline = require("tabby.presets").active_wins_at_tail
  })
end

return M
