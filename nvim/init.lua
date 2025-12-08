-- Set runtimepath for Neovim
vim.o.runtimepath = vim.o.runtimepath .. ',~/.vim'
vim.o.runtimepath = vim.o.runtimepath .. ',~/.vim/after'

-- Set packpath to match runtimepath
vim.o.packpath = vim.o.runtimepath

-- Load Vim configuration
vim.cmd('source ~/.vimrc')

-- save last cursor position
-- https://github.com/neovim/neovim/issues/16339#issuecomment-1457394370
vim.api.nvim_create_autocmd('BufRead', {
  callback = function(opts)
    vim.api.nvim_create_autocmd('BufWinEnter', {
      once = true,
      buffer = opts.buf,
      callback = function()
        local ft = vim.bo[opts.buf].filetype
        local last_known_line = vim.api.nvim_buf_get_mark(opts.buf, '"')[1]
        if
          not (ft:match('commit') and ft:match('rebase'))
          and last_known_line > 1
          and last_known_line <= vim.api.nvim_buf_line_count(opts.buf)
        then
          vim.api.nvim_feedkeys([[g`"]], 'nx', false)
        end
      end,
    })
  end,
})

-- WSL clipboard integration
-- Requires win32yank.exe: install via `choco install win32yank` in powershell
local is_wsl = vim.fn.has("wsl") == 1
local win32yank_path = "/mnt/c/ProgramData/chocolatey/lib/win32yank/tools/win32yank.exe"
local has_win32yank = vim.fn.filereadable(win32yank_path) == 1
if is_wsl and has_win32yank then
  vim.g.clipboard = {
    name = "WslClipboard",
    copy = {
      ["+"] = "/mnt/c/ProgramData/chocolatey/lib/win32yank/tools/win32yank.exe -i --crlf",
      ["*"] = "/mnt/c/ProgramData/chocolatey/lib/win32yank/tools/win32yank.exe -i --crlf",
    },
    paste = {
      ["+"] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
      ["*"] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
    },
    cache_enabled = 0,
  }
end

