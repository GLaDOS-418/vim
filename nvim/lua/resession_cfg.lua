local resession = require('resession')

-- Periodically save the current session
resession.setup({
  autosave = {
    enabled = true,
    interval = 60,
    notify = true,
  },
})

-- Resession does NOTHING automagically, so we have to set up some keymaps
-- Bind `save_tab` instead of `save`
vim.keymap.set('n', '<leader>ss', resession.save_tab)
vim.keymap.set('n', '<leader>sl', resession.load)
vim.keymap.set('n', '<leader>sd', resession.delete)

-- Automatically save a session when you exit Neovim
vim.api.nvim_create_autocmd("VimLeavePre", {
  callback = function()
    -- Always save a special session named "last"
    resession.save("last")
  end,
})

-- Create one session per directory
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    -- Only load the session if nvim was started with no args
    if vim.fn.argc(-1) == 0 then
      -- Save these to a different directory, so our manual sessions don't get polluted
      resession.load(vim.fn.getcwd(), { dir = "dirsession", silence_errors = true })
    end
  end,
})
vim.api.nvim_create_autocmd("VimLeavePre", {
  callback = function()
    resession.save(vim.fn.getcwd(), { dir = "dirsession", notify = false })
  end,
})


-- Create one session per git branch
local function get_session_name()
  local name = vim.fn.getcwd()
  local branch = vim.trim(vim.fn.system("git branch --show-current"))
  if vim.v.shell_error == 0 then
    return name .. branch
  else
    return name
  end
end
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    -- Only load the session if nvim was started with no args
    if vim.fn.argc(-1) == 0 then
      resession.load(get_session_name(), { dir = "dirsession", silence_errors = true })
    end
  end,
})
vim.api.nvim_create_autocmd("VimLeavePre", {
  callback = function()
    resession.save(get_session_name(), { dir = "dirsession", notify = false })
  end,
})
