# The `nord-theme` CLI: flips the shared dark/light state and applies it
# to tmux (instant) and ghostty (rewrites the config file; manual reload
# needed — see README). nvim just reads the state file on next launch.
{ pkgs, tmuxShare, ghosttyThemes }:
pkgs.writeShellApplication {
  name = "nord-theme";
  runtimeInputs = [ pkgs.tmux ];
  text = ''
    state_dir="''${XDG_STATE_HOME:-$HOME/.local/state}/nord"
    state_file="$state_dir/theme"
    ghostty_config="$HOME/.config/ghostty/config"
    ghostty_themes_dir="${ghosttyThemes}/share/ghostty/themes"
    tmux_share="${tmuxShare}/share/nord"

    usage() {
      echo "usage: nord-theme <set dark|light | toggle | status>" >&2
      exit 1
    }

    current() {
      mkdir -p "$state_dir"
      if [ -f "$state_file" ]; then
        cat "$state_file"
      else
        echo "dark"
      fi
    }

    apply_tmux() {
      variant="$1"
      if tmux info >/dev/null 2>&1; then
        tmux source-file "$tmux_share/nord-$variant.tmux.conf"
        echo "tmux: reloaded instantly."
      else
        echo "tmux: no running server, will pick up nord-$variant.tmux.conf next session."
      fi
    }

    apply_ghostty() {
      variant="$1"
      theme_file="$ghostty_themes_dir/nord-$variant"
      if [ ! -f "$theme_file" ]; then
        echo "ghostty: generated theme nord-$variant not found at $theme_file" >&2
        return 1
      fi
      mkdir -p "$(dirname "$ghostty_config")"
      {
        if [ -f "$ghostty_config" ]; then
          grep -v '^theme' "$ghostty_config" || true
        fi
        echo "theme = nord-$variant"
      } > "$ghostty_config.new"
      mv "$ghostty_config.new" "$ghostty_config"
      echo "ghostty: config updated to nord-$variant. Press your reload_config keybind (or open a new window) to apply it — ghostty has no external reload command."
    }

    set_variant() {
      variant="$1"
      case "$variant" in
        dark | light) ;;
        *) usage ;;
      esac
      mkdir -p "$state_dir"
      tmp="$state_file.tmp"
      echo "$variant" > "$tmp"
      mv "$tmp" "$state_file"
      apply_tmux "$variant"
      apply_ghostty "$variant" || true
      echo "nvim: will use $variant on next launch (not live-reloaded)."
      echo "nord-theme: now $variant"
    }

    cmd="''${1:-}"
    case "$cmd" in
      set)
        [ $# -eq 2 ] || usage
        set_variant "$2"
        ;;
      toggle)
        now="$(current)"
        if [ "$now" = "dark" ]; then
          set_variant "light"
        else
          set_variant "dark"
        fi
        ;;
      status)
        current
        ;;
      *)
        usage
        ;;
    esac
  '';
}
