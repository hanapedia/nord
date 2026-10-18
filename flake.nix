{
  description = "Nord-derived palette and generated theme files for Neovim, tmux, and Ghostty";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forEachSystem = f: nixpkgs.lib.genAttrs systems f;
      palette = import ./palette;
    in
    {
      lib = import ./lib { inherit (nixpkgs) lib; };

      packages = forEachSystem (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          nordLib = self.lib;
        in
        rec {
          tmux = import ./tmux { inherit pkgs palette nordLib; };
          ghostty = import ./ghostty { inherit pkgs palette nordLib; };
          nord-theme = import ./toggle {
            inherit pkgs;
            tmuxShare = tmux;
            ghosttyThemes = ghostty;
          };
          default = nord-theme;
        });

      checks = forEachSystem (system:
        import ./tests {
          pkgs = nixpkgs.legacyPackages.${system};
          packages = self.packages.${system};
          nordLib = self.lib;
          palette = palette;
          src = self;
        });

      homeModules.default = import ./home-manager/module.nix { inherit self; };
    };
}
