require("mason").setup({
  ui = {
    border = "single", -- winborder give error
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗"
    }
  }
})
