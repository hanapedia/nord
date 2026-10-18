# `nix flake check` entry point: builds every package and runs a few
# sanity assertions on the generated output.
{ pkgs, packages, nordLib, palette, src }:
let
  render = nordLib.render;

  # assertHexPalette throws at eval time on any non-hex value, so forcing
  # both variants here is the whole check.
  paletteCheck =
    builtins.deepSeq (render.assertHexPalette palette.dark) (
      builtins.deepSeq (render.assertHexPalette palette.light) (
        pkgs.runCommand "nord-check-palette" { } ''touch "$out"''
      )
    );

  # Headlessly loads the actual plugin (colors/ + lua/nord at the repo
  # root) and exercises both colorschemes + toggle(), failing the build on
  # any Lua error.
  nvimCheck = pkgs.runCommand "nord-check-nvim" { nativeBuildInputs = [ pkgs.neovim-unwrapped ]; } ''
    export HOME="$TMPDIR"
    nvim --headless --clean --cmd "set runtimepath+=${src}" \
      -c "lua vim.cmd.colorscheme('nord'); assert(vim.g.colors_name == 'nord')" \
      -c "lua assert(vim.api.nvim_get_hl(0, {name='Normal'}).bg ~= nil)" \
      -c "lua vim.cmd.colorscheme('nord-light'); assert(vim.g.colors_name == 'nord-light')" \
      -c "lua require('nord').toggle(); assert(vim.g.colors_name == 'nord')" \
      -c "qa"
    touch "$out"
  '';

  tmuxCheck = pkgs.runCommand "nord-check-tmux" { } ''
    grep -q "status-style" "${packages.tmux}/share/nord/nord-dark.tmux.conf"
    grep -q "status-style" "${packages.tmux}/share/nord/nord-light.tmux.conf"
    test -x "${packages.tmux}/share/nord/nord.tmux"
    touch "$out"
  '';

  ghosttyCheck = pkgs.runCommand "nord-check-ghostty" { } ''
    grep -q "^palette = 0=" "${packages.ghostty}/share/ghostty/themes/nord-dark"
    grep -q "^background = " "${packages.ghostty}/share/ghostty/themes/nord-dark"
    grep -q "^palette = 15=" "${packages.ghostty}/share/ghostty/themes/nord-light"
    touch "$out"
  '';

  toggleCheck = pkgs.runCommand "nord-check-toggle" { } ''
    test -x "${packages.nord-theme}/bin/nord-theme"
    touch "$out"
  '';
in
{
  inherit paletteCheck nvimCheck tmuxCheck ghosttyCheck toggleCheck;
}
