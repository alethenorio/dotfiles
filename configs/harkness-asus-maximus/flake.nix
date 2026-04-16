{
  description = "NixOS and Home Manager configuration for harkness";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
      claude-code = import ../../modules/home-manager/claude-code { inherit pkgs-unstable; };
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
          dotfilesDir = "/home/alethenorio/code/dotfiles";
        };
        modules = [ ./home.nix ];
      };
    };
}
