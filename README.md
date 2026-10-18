# nord

A single Nord-derived color palette, a minimal Neovim colorscheme plugin
built directly from it, and matching dark/light theme files for tmux and
Ghostty — plus a `nord-theme` command to toggle between dark and light
everywhere.

## Why

Previously each tool had its own, independently-maintained Nord theme
(`mynord.nvim`, the community tmux Nord plugin, Ghostty's built-in `Nord`
theme), none of which agreed with each other exactly, and only nvim had a
light variant. `mynord.nvim` itself (a fork of the long-unmaintained
`onenord.nvim`) was also old and carried ~900 lines of per-plugin highlight
groups. This repo replaces all of that with one palette and one minimal
colorscheme, consistent everywhere.

## Neovim plugin

The repo root doubles as a standard Neovim colorscheme plugin — `colors/`
and `lua/nord/` live at the top level, so any plugin manager can point
straight at it:

```lua
-- lazy.nvim
{ "hanapedia/nord", lazy = false, priority = 1000 }
```

```vim
colorscheme nord        " dark
colorscheme nord-light  " light
```

```lua
require("nord").toggle()          -- flip dark/light in the current session
require("nord").initial_variant() -- "dark" or "light", read from the shared
                                   -- nord-theme state file (see below);
                                   -- call this yourself at startup if you
                                   -- want nvim to open in whatever variant
                                   -- was last toggled, e.g.:
vim.cmd.colorscheme(require("nord").initial_variant() == "light" and "nord-light" or "nord")
```

There is no `setup()` call and no options table — it's deliberately just
`colors/nord.lua`, `colors/nord-light.lua`, and three small files under
`lua/nord/` (`palette.lua`, `highlights.lua`, `init.lua`). Highlight coverage
is core editor UI + base syntax + Treesitter `@captures` + LSP
diagnostics/semantic tokens — no bespoke per-plugin groups (telescope, cmp,
gitsigns, lualine, ...). Those plugins mostly read the same base/treesitter
groups already, so they inherit a consistent look for free.

**`mynord.nvim` is now superseded** — nothing in this repo depends on it,
and it can be removed from wherever it's installed once you've switched over.

## Palette

`palette/default.nix` (Nix, used by the tmux/ghostty generators below) and
`lua/nord/palette.lua` (plain Lua, used by the nvim plugin) hold the same
values — duplicated rather than generated, so the nvim plugin works from a
plain git clone with no Nix/build step. If you change one, change the other.
Each variant is a flat table of named colors (`fg`, `bg`, `gray`, `cyan`,
`blue`, `green`, `red`, `purple`, `orange`, `yellow`, plus semantic roles
like `error`/`warn`/`info`/`hint`, diff colors, and UI roles like
`active`/`float`/`selection`).

## What's generated (Nix)

- `packages.tmux` → `nord-dark.tmux.conf` / `nord-light.tmux.conf` (plain
  `set-option` statements) plus a `nord.tmux` wrapper that sources
  whichever variant the shared state file points at.
- `packages.ghostty` → `nord-dark` / `nord-light` theme files in Ghostty's
  native `key = value` format.
- `packages.nord-theme` → the toggle CLI (see below).

All three terminal-color mappings (Ghostty's palette, nvim's `:terminal` —
set directly in `lua/nord/init.lua` — and implicitly tmux) use the same
palette → ANSI-slot assignment (see `lib/ansi.nix`, mirrored in
`lua/nord/init.lua`'s `terminal_colors()`).

## Toggling

```
nord-theme set dark
nord-theme set light
nord-theme toggle
nord-theme status
```

State lives in `$XDG_STATE_HOME/nord/theme` (defaults to
`~/.local/state/nord/theme`), containing just `dark` or `light`.

What actually happens on toggle:
- **tmux**: reloaded instantly via `tmux source-file`, if a server is running.
- **ghostty**: the `theme = ` line in `~/.config/ghostty/config` is rewritten.
  **Ghostty has no external "reload config" command** — only an in-terminal
  `reload_config` keybind — so you still need to press that keybind (or open
  a new window) to see the change. `nord-theme` prints this reminder.
- **nvim**: not live-reloaded. Call `require("nord").initial_variant()` at
  startup (see above) to have the next nvim instance open in whatever
  variant you last toggled to.

## Home Manager integration

This flake exposes `homeModules.default` for tmux/ghostty/the toggle CLI
(the nvim plugin is installed via your plugin manager, not this module):

```nix
# flake.nix
inputs.nord.url = "path:/home/hanapedia/code/src/github.com/hanapedia/nord"; # or github:hanapedia/nord once pushed

# home configuration
imports = [ nord.homeModules.default ];
programs.nord-theme = {
  enable = true;
  defaultVariant = "dark";
};
```

This installs the `nord-theme` command, wires the tmux theme into
`programs.tmux.extraConfig`, and installs the ghostty theme files under
`~/.config/ghostty/themes/`.

**Not done by this module** (left for the dotfiles repo, as a follow-up):
dropping the old `tmuxPlugins.nord` entry and the hardcoded `theme = Nord`
line from the existing `tmux.nix`/`ghostty.nix`, and replacing whatever
currently installs `mynord.nvim` (via `hanapedia/nvimc`) with this plugin.

## Development

```
nix flake check   # builds everything + sanity checks, including a headless
                  # nvim smoke test of colors/nord{,-light}.lua and toggle()
nix build .#tmux && cat result/share/nord/nord-dark.tmux.conf
nix build .#ghostty && cat result/share/ghostty/themes/nord-dark
nix build .#nord-theme && result/bin/nord-theme status
nvim --headless --clean --cmd "set runtimepath+=." -c "colorscheme nord"
```
