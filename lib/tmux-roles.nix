# Maps the shared palette onto tmux-specific semantic roles. Pure function
# of the existing palette values — introduces no new raw hex literals.
base:
{
  status_bg = base.bg;
  status_fg = base.fg;

  window_active_fg = base.cyan;
  window_inactive_fg = base.light_gray;

  pane_border_fg = base.highlight_dark;
  pane_active_border_fg = base.blue;

  message_bg = base.float;
  message_fg = base.fg;

  mode_fg = base.yellow;

  clock_fg = base.blue;
}
