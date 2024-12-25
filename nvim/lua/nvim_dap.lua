----------------------------------------------
-- https://github.com/mfussenegger/nvim-dap
----------------------------------------------
local dap = require('dap')  -- required by nvim-dap-ui as well
dap.adapters.lldb = {
  type = 'executable',
  command = '/usr/bin/lldb-vscode-17', -- must be absolute path
  name = 'lldb'
}

dap.configurations.cpp = {
  {
    name = 'Launch',
    type = 'lldb',
    request = 'launch',
    -- program = function()
    --   return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/build', 'file')
    -- end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
    args = {},

    -- 💀
    -- if you change `runInTerminal` to true, you might need to change the yama/ptrace_scope setting:
    --
    --    echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
    --
    -- Otherwise you might get the following error:
    --
    --    Error on launch: Failed to attach to the target process
    --
    -- But you should be aware of the implications:
    -- https://www.kernel.org/doc/html/latest/admin-guide/LSM/Yama.html
    -- runInTerminal = false,
  },
}


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


