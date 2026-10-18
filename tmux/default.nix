# Renders nord-dark.tmux.conf / nord-light.tmux.conf plus a nord.tmux
# wrapper script that picks the active variant from the shared state file
# and sources it. Output: $out/share/nord/{nord-dark.tmux.conf,nord-light.tmux.conf,nord.tmux}
{ pkgs, palette, nordLib }:
let
  renderConf = import ./theme.tmux.conf.nix;
  darkConf = renderConf (nordLib.tmuxRoles palette.dark);
  lightConf = renderConf (nordLib.tmuxRoles palette.light);

  wrapper = pkgs.writeShellScriptBin "nord.tmux" ''
    set -euo pipefail
    state_file="''${XDG_STATE_HOME:-$HOME/.local/state}/nord/theme"
    variant="$(cat "$state_file" 2>/dev/null || echo dark)"
    dir="$(cd "$(dirname "''${BASH_SOURCE[0]}")" && pwd)"
    tmux source-file "$dir/nord-$variant.tmux.conf"
  '';
in
pkgs.runCommand "nord-tmux"
  {
    darkConf = darkConf;
    lightConf = lightConf;
    passAsFile = [ "darkConf" "lightConf" ];
  } ''
  mkdir -p "$out/share/nord"
  cp "$darkConfPath" "$out/share/nord/nord-dark.tmux.conf"
  cp "$lightConfPath" "$out/share/nord/nord-light.tmux.conf"
  cp "${wrapper}/bin/nord.tmux" "$out/share/nord/nord.tmux"
  chmod +x "$out/share/nord/nord.tmux"
''
