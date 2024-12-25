local resession = require('resession')

-- Setup resession with autosave configuration
resession.setup({
  autosave = {
    enabled = true,
    interval = 60, -- Save every 60 seconds
    notify = false,
  },
})

-- Helper function to get session name based on git branch
local function get_session_name()
  local cwd = vim.fn.getcwd()
  local branch = vim.trim(vim.fn.system("git branch --show-current"))
  if vim.v.shell_error == 0 and branch ~= "" then
    return cwd .. "-" .. branch
  end
  return cwd
end

-- Check if the current directory is home or root
local function is_home_or_root(cwd)
  local home = vim.fn.expand("~")
  return cwd == home or cwd == "/"
end

-- Keymaps for manual session management
vim.keymap.set('n', '<leader>ss', resession.save_tab, { desc = "Save tab session" })
vim.keymap.set('n', '<leader>sl', function()
  resession.load(get_session_name(), { dir = "dirsession" })
end, { desc = "Load session" })
vim.keymap.set('n', '<leader>sd', resession.delete, { desc = "Delete session" })

-- Unified save logic in a single autocommand
vim.api.nvim_create_autocmd("VimLeavePre", {
  callback = function()
    local cwd = vim.fn.getcwd()

    -- Skip saving if in HOME or ROOT directory
    if is_home_or_root(cwd) then
      return
    end

    -- Determine session name: branch-based if possible, else directory-based
    local session_name = get_session_name()

    -- Save session
    resession.save(session_name, { dir = "dirsession", notify = false })
  end,
})
