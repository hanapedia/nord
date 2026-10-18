-- Mirrors palette/default.nix at the repo root. Kept as plain Lua (rather
-- than generated) so this plugin works from a normal plugin-manager clone
-- with no Nix/build step. If you change one, change the other.
return {
  dark = {
    fg = "#D8DEE9",
    fg_light = "#ECEFF4",
    bg = "#2E3440",

    gray = "#4C566A",
    light_gray = "#5E6B84",

    cyan = "#88C0D0",
    blue = "#81A1C1",
    dark_blue = "#5E81AC",

    green = "#A3BE8C",
    light_green = "#8FBCBB",

    dark_red = "#BF616A",
    red = "#BF616A",
    light_red = "#CC7A81",

    pink = "#D88FB3",
    dark_pink = "#C76698",

    orange = "#D08770",
    yellow = "#EBCB8B",

    purple = "#B48EAD",
    light_purple = "#C7A0C3",

    none = "NONE",

    error = "#BF616A",
    warn = "#D08770",
    info = "#A3BE8C",
    hint = "#B48EAD",

    diff_add = "#A3BE8C",
    diff_add_bg = "#3B4A3E",
    diff_change = "#5E81AC",
    diff_change_bg = "#374A5E",
    diff_remove = "#BF616A",
    diff_remove_bg = "#4C3337",
    diff_text_bg = "#3E5774",

    active = "#333A47",
    float = "#3B4252",
    highlight = "#3F4758",
    highlight_dark = "#434C5E",
    selection = "#4C566A",
  },

  light = {
    fg = "#3B4252",
    fg_light = "#4C566A",
    bg = "#D8DEE9",

    gray = "#8FA0BD",
    light_gray = "#566279",

    cyan = "#2E6978",
    blue = "#426298",
    dark_blue = "#395C8A",

    green = "#476B3F",
    light_green = "#3B6A66",

    dark_red = "#A63F4A",
    red = "#A63F4A",
    light_red = "#9D4935",

    pink = "#8F4B77",
    dark_pink = "#8C4575",

    orange = "#915230",
    yellow = "#7C5C24",

    purple = "#7B5385",
    light_purple = "#7B5486",

    none = "NONE",

    error = "#A63F4A",
    warn = "#915230",
    info = "#476B3F",
    hint = "#7B5385",

    diff_add = "#476B3F",
    diff_add_bg = "#C2CDD0",
    diff_change = "#395C8A",
    diff_change_bg = "#C0CADB",
    diff_remove = "#A63F4A",
    diff_remove_bg = "#CFC1CC",
    diff_text_bg = "#A8B7CC",

    active = "#D2D8E4",
    float = "#CAD0DC",
    highlight = "#C5CCD7",
    highlight_dark = "#C1C7D3",
    selection = "#B7BECA",
  },
}
