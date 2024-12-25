----------------------------------------------
-- https://github.com/mfussenegger/nvim-dap
----------------------------------------------
local dap = require('dap')  -- required by nvim-dap-ui as well

----------------------------------------------
-- KEYMAPS
----------------------------------------------
vim.keymap.set('n', '<F5>', function() require('dap').continue() end)
vim.keymap.set('n', '<F10>', function() require('dap').step_over() end)
vim.keymap.set('n', '<F11>', function() require('dap').step_into() end)
vim.keymap.set('n', '<F12>', function() require('dap').step_out() end)
vim.keymap.set('n', '<F9>', function() require('dap').toggle_breakpoint() end)
vim.keymap.set('n', '<Leader>lp', function() require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end)
vim.keymap.set('n', '<Leader>dr', function() require('dap').repl.open() end)
vim.keymap.set('n', '<Leader>dl', function() require('dap').run_last() end)
vim.keymap.set({'n', 'v'}, '<Leader>dh', function()
  require('dap.ui.widgets').hover()
end)
vim.keymap.set({'n', 'v'}, '<Leader>dp', function()
  require('dap.ui.widgets').preview()
end)
vim.keymap.set('n', '<Leader>df', function()
  local widgets = require('dap.ui.widgets')
  widgets.centered_float(widgets.frames)
end)
vim.keymap.set('n', '<Leader>ds', function()
  local widgets = require('dap.ui.widgets')
  widgets.centered_float(widgets.scopes)
end)

----------------------------------------------
-- LANGUAGE SPECIFIC
----------------------------------------------
--- C++
dap.adapters.codelldb = {
  type = 'server',
  port = "${port}",
  executable = {
    command = '/home/glados/thirdparty/codelldb/extension/adapter/codelldb',
    args = {"--port", "${port}"},

    -- On windows you may have to uncomment this:
    -- detached = false,
  }
}

dap.configurations.cpp = {
  {
    name = "Debug",
    type = "codelldb",
    request = "launch",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
  },
}

--- C
dap.configurations.c = dap.configurations.cpp

--- RUST
dap.configurations.rust = dap.configurations.cpp

--------------------------------------------
-- https://github.com/rcarriga/nvim-dap-ui
--------------------------------------------
require('dapui').setup()
local dapui = require("dapui")
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

-----------------------------------------
-- https://github.com/leoluz/nvim-dap-go
-----------------------------------------
require('dap-go').setup()


-------------------------------------------------------
-- https://github.com/theHamsta/nvim-dap-virtual-text
-------------------------------------------------------
require("nvim-dap-virtual-text").setup {
  commented = false,
  highlight_changed_variables = true,
  all_frames = true,
  show_stop_reason = true,
}


