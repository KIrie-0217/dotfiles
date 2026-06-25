{
  description = "iriekos dotfiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    glipt = {
      url = "github:KIrie-0217/glipt";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    gleeam-code = {
      url = "github:KIrie-0217/gleeam_code";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    herdr = {
      url = "github:ogulcancelik/herdr";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, glipt, gleeam-code, herdr, ... }:
    let
      mkHome = { system, extraModules ? [] }:
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
          modules = [ ./home.nix ] ++ extraModules;
          extraSpecialArgs = {
            glipt-pkg = glipt.packages.${system}.default;
            gleeam-code-pkg = gleeam-code.packages.${system}.default;
            herdr-pkg = herdr.packages.${system}.default;
          };
        };
    in
    {
      homeConfigurations = {
        # macOS (local)
        "iriekos@mac" = mkHome {
          system = "aarch64-darwin";
        };
        # Linux x86_64 (EC2, etc.)
        "iriekos@linux" = mkHome {
          system = "x86_64-linux";
        };
        # Linux aarch64 (Graviton, etc.)
        "iriekos@linux-arm" = mkHome {
          system = "aarch64-linux";
        };
      };
    };
}
