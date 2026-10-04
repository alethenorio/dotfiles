{
  description = "NixOS and Home Manager configuration for harkness";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    claude-desktop = {
      url = "github:aaddrick/claude-desktop-debian";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs =
    {
      nixpkgs,
      nixpkgs-unstable,
      claude-desktop,
      home-manager,
      plasma-manager,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
      claude-code = import ../../modules/home-manager/claude-code { inherit pkgs-unstable; };
      claude-desktop-pkg = claude-desktop.packages.${system}.claude-desktop-fhs;
    in
    {
      nixosConfigurations.harkness = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit pkgs-unstable;
        };
        modules = [
          ./configuration.nix
        ];
      };

      homeConfigurations."alethenorio" = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
        extraSpecialArgs = {
          inherit pkgs-unstable claude-code;
          claude-desktop = claude-desktop-pkg;
          dotfilesDir = "/home/alethenorio/code/dotfiles";
        };
        modules = [
          plasma-manager.homeModules.plasma-manager
          ./home.nix
        ];
      };
    };
}
