require("catppuccin").setup({
  flavour = "mocha",
  color_overrides = {
    mocha = {
      base = "#12121a",
      mantle = "#12121a",
      crust = "#12121a",
    },
  },
  transparent_background = true,
})
vim.cmd.colorscheme("catppuccin-mocha")
vim.api.nvim_set_hl(0, "LineNr", { fg = "#7f849c" })
