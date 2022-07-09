local M = {}

local Log = require "dark.core.log"
local if_nil = vim.F.if_nil

local function git_cmd(opts)
  local plenary_loaded, Job = pcall(require, "plenary.job")
  if not plenary_loaded then
    return 1, { "" }
  end

  opts = opts or {}
  opts.cwd = opts.cwd or get_dark_base_dir()

  local stderr = {}
  local stdout, ret = Job
    :new({
      command = "git",
      args = opts.args,
      cwd = opts.cwd,
      on_stderr = function(_, data)
        table.insert(stderr, data)
      end,
    })
    :sync()

  if not vim.tbl_isempty(stderr) then
    Log:debug(stderr)
  end

  if not vim.tbl_isempty(stdout) then
    Log:debug(stdout)
  end

  return ret, stdout, stderr
end

local function safe_deep_fetch()
  local ret, result, error = git_cmd { args = { "rev-parse", "--is-shallow-repository" } }
  if ret ~= 0 then
    Log:error(vim.inspect(error))
    return
  end
  -- git fetch --unshallow will cause an error on a a complete clone
  local fetch_mode = result[1] == "true" and "--unshallow" or "--all"
  ret = git_cmd { args = { "fetch", fetch_mode } }
  if ret ~= 0 then
    Log:error("Git fetch failed! Please pull the changes manually in " .. get_dark_base_dir())
    return
  end
  return true
end

---pulls the latest changes from github
function M.update_base_dark()
  Log:info "Checking for updates"

  if not safe_deep_fetch() then
    return
  end

  local ret

  ret = git_cmd { args = { "diff", "--quiet", "@{upstream}" } }
  if ret == 0 then
    Log:info "DarkVim is already up-to-date"
    return
  end

  ret = git_cmd { args = { "merge", "--ff-only", "--progress" } }
  if ret ~= 0 then
    Log:error("Update failed! Please pull the changes manually in " .. get_dark_base_dir())
    return
  end

  return true
end

---Switch Darkvim to the specified development branch
---@param branch string
function M.switch_dark_branch(branch)
  if not safe_deep_fetch() then
    return
  end
  local args = { "switch", branch }

  if branch:match "^[0-9]" then
    -- avoids producing an error for tags
    vim.list_extend(args, { "--detach" })
  end

  local ret = git_cmd { args = args }
  if ret ~= 0 then
    Log:error "Unable to switch branches! Check the log for further information"
    return
  end
  return true
end

---Get the current Darkvim development branch
---@return string|nil
function M.get_dark_branch()
  local _, results = git_cmd { args = { "rev-parse", "--abbrev-ref", "HEAD" } }
  local branch = if_nil(results[1], "")
  return branch
end

---Get currently checked-out tag of Darkvim
---@return string
function M.get_dark_tag()
  local args = { "describe", "--tags", "--abbrev=0" }

  local _, results = git_cmd { args = args }
  local tag = if_nil(results[1], "")
  return tag
end

---Get currently running version of Darkvim
---@return string
function M.get_dark_version()
  local current_branch = M.get_dark_branch()

  local dark_version
  if current_branch ~= "HEAD" or "" then
    dark_version = current_branch .. "-" .. M.get_dark_current_sha()
  else
    dark_version = "v" .. M.get_dark_tag()
  end
  return dark_version
end

---Get the commit hash of currently checked-out commit of Darkvim
---@return string|nil
function M.get_dark_current_sha()
  local _, log_results = git_cmd { args = { "log", "--pretty=format:%h", "-1" } }
  local abbrev_version = if_nil(log_results[1], "")
  return abbrev_version
end

return M
