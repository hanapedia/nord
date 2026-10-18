-- lualine theme matching the active nord variant. Usage:
--   require('lualine').setup({ options = { theme = 'nord' } })
-- Picks dark/light the same way nord.init does: read at require-time, not
-- reactive to a later require('nord').toggle() -- same limitation
-- mynord.nvim's own lualine theme had, and consistent with nvim not being
-- live-reloaded on theme toggle (see README).
local palette = require("nord.palette")

local variant = vim.g.colors_name == "nord-light" and "light" or "dark"
local c = palette[variant]

return {
  normal = {
    a = { fg = c.bg, bg = c.cyan, gui = "bold" },
    b = { fg = c.cyan, bg = c.highlight },
    c = { fg = c.fg, bg = c.active },
  },
  insert = {
    a = { fg = c.bg, bg = c.green, gui = "bold" },
    b = { fg = c.green, bg = c.highlight },
  },
  command = {
    a = { fg = c.bg, bg = c.yellow, gui = "bold" },
    b = { fg = c.yellow, bg = c.highlight },
  },
  visual = {
    a = { fg = c.bg, bg = c.purple, gui = "bold" },
    b = { fg = c.purple, bg = c.highlight },
  },
  replace = {
    a = { fg = c.bg, bg = c.red, gui = "bold" },
    b = { fg = c.red, bg = c.highlight },
  },
  inactive = {
    a = { fg = c.light_gray, bg = c.float, gui = "bold" },
    b = { fg = c.light_gray, bg = c.float },
    c = { fg = c.light_gray, bg = c.active },
  },
}
