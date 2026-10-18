-- hanapedia/nord: a minimal Nord-derived colorscheme, dark + light.
-- No setup() call, no options. Use :colorscheme nord / nord-light, or
-- require("nord").toggle() to flip between them.
local M = {}

local function terminal_colors(c)
  -- Same palette -> ANSI-slot mapping as lib/ansi.nix, so nvim's
  -- :terminal agrees with the tmux/ghostty themes generated from the
  -- same repo.
  vim.g.terminal_color_0 = c.float
  vim.g.terminal_color_1 = c.red
  vim.g.terminal_color_2 = c.green
  vim.g.terminal_color_3 = c.yellow
  vim.g.terminal_color_4 = c.blue
  vim.g.terminal_color_5 = c.purple
  vim.g.terminal_color_6 = c.cyan
  vim.g.terminal_color_7 = c.fg
  vim.g.terminal_color_8 = c.selection
  vim.g.terminal_color_9 = c.red
  vim.g.terminal_color_10 = c.green
  vim.g.terminal_color_11 = c.yellow
  vim.g.terminal_color_12 = c.blue
  vim.g.terminal_color_13 = c.purple
  vim.g.terminal_color_14 = c.cyan
  vim.g.terminal_color_15 = c.fg_light
end

-- variant: "dark" or "light"
function M.apply(variant)
  variant = variant == "light" and "light" or "dark"

  local colors = require("nord.palette")[variant]
  local highlights = require("nord.highlights").build(colors)

  vim.cmd.highlight("clear")
  if vim.fn.exists("syntax_on") == 1 then
    vim.cmd.syntax("reset")
  end
  vim.o.termguicolors = true
  vim.o.background = variant
  vim.g.colors_name = variant == "light" and "nord-light" or "nord"

  for group, hl in pairs(highlights) do
    vim.api.nvim_set_hl(0, group, hl)
  end

  terminal_colors(colors)
end

function M.toggle()
  local current = vim.g.colors_name == "nord-light" and "light" or "dark"
  M.apply(current == "light" and "dark" or "light")
end

-- Reads the variant last set by the `nord-theme` CLI (see
-- github.com/hanapedia/nord's toggle/ -- shared across tmux/ghostty too),
-- defaulting to "dark" if that file doesn't exist. Purely a convenience:
-- call it yourself if you want nvim to start in whatever variant you last
-- toggled to, e.g.:
--   vim.cmd.colorscheme(require("nord").initial_variant() == "light" and "nord-light" or "nord")
function M.initial_variant()
  local state_home = os.getenv("XDG_STATE_HOME") or (os.getenv("HOME") .. "/.local/state")
  local f = io.open(state_home .. "/nord/theme", "r")
  if not f then
    return "dark"
  end
  local variant = f:read("l")
  f:close()
  return variant == "light" and "light" or "dark"
end

return M
