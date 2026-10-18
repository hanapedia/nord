{ lib }:
{
  render = import ./render.nix { inherit lib; };
  ansi = import ./ansi.nix;
  tmuxRoles = import ./tmux-roles.nix;
}
