{ self }:
{ config, lib, pkgs, ... }:
let
  cfg = config.programs.nord-theme;
  system = pkgs.system;
  pkgsOut = self.packages.${system};
in
{
  options.programs.nord-theme = {
    enable = lib.mkEnableOption "the Nord theme toggle for nvim/tmux/ghostty";

    defaultVariant = lib.mkOption {
      type = lib.types.enum [ "dark" "light" ];
      default = "dark";
      description = "Variant to seed the shared state file with on first activation.";
    };

    tmux.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Wire the generated tmux theme into programs.tmux.extraConfig.";
    };

    ghostty.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Install the generated ghostty theme files under ~/.config/ghostty/themes.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgsOut.nord-theme ];

    # Neovim is a plain plugin now (colors/ + lua/nord at the repo root) —
    # install it via your plugin manager (lazy.nvim/packer), not here.

    programs.tmux.extraConfig = lib.mkIf cfg.tmux.enable ''
      run-shell "bash ${pkgsOut.tmux}/share/nord/nord.tmux"
    '';

    xdg.configFile."ghostty/themes/nord-dark" = lib.mkIf cfg.ghostty.enable {
      source = "${pkgsOut.ghostty}/share/ghostty/themes/nord-dark";
    };
    xdg.configFile."ghostty/themes/nord-light" = lib.mkIf cfg.ghostty.enable {
      source = "${pkgsOut.ghostty}/share/ghostty/themes/nord-light";
    };

    home.activation.nordStateInit = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      state_dir="''${XDG_STATE_HOME:-$HOME/.local/state}/nord"
      state_file="$state_dir/theme"
      run mkdir -p "$state_dir"
      if [ ! -f "$state_file" ]; then
        run bash -c 'echo ${cfg.defaultVariant} > "$1"' -- "$state_file"
      fi
    '';
  };
}
