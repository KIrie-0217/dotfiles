{
  description = "iriekos dotfiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }:
    let
      mkHome = { system, extraModules ? [] }:
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
          modules = [ ./home.nix ] ++ extraModules;
        };
    in
    {
      homeConfigurations = {
        # macOS (local)
        "iriekos@mac" = mkHome {
          system = "aarch64-darwin";
        };
        # Linux (EC2, etc.)
        "iriekos@linux" = mkHome {
          system = "x86_64-linux";
        };
      };
    };
}
