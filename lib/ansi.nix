# Maps the shared palette onto the standard 16-slot terminal ANSI palette,
# using the same role assignment as mynord.nvim's `theme.load_terminal()`
# (lua/mynord/theme.lua), so ghostty's terminal colors, nvim's :terminal,
# and tmux all agree on what "ANSI red/green/blue/..." means.
base:
{
  "0" = base.float;
  "1" = base.red;
  "2" = base.green;
  "3" = base.yellow;
  "4" = base.blue;
  "5" = base.purple;
  "6" = base.cyan;
  "7" = base.fg;
  "8" = base.selection;
  "9" = base.red;
  "10" = base.green;
  "11" = base.yellow;
  "12" = base.blue;
  "13" = base.purple;
  "14" = base.cyan;
  "15" = base.fg_light;
}
