{ config, pkgs, ... }:

{
  imports = [
    ../../modules/home-manager/git
    ../../modules/home-manager/neovim
    ../../modules/home-manager/bash
  ];
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "alethenorio";
  home.homeDirectory = "/home/alethenorio";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  nixpkgs.config.allowUnfree = true;

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    bitwarden-desktop
    curl
    discord
    file
    nerd-fonts.sauce-code-pro
    nerd-fonts.fira-code
    nerd-fonts.noto
    nethogs
    nix-tree
    speedtest-cli
    udisks
  ];

  programs = {
    firefox = {
      enable = true;
    };
    gh = {
      enable = true;
    };
    go = {
      enable = true;
      package = pkgs.go_1_23;
      goPath = "go";
      goBin = "go/bin";
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
