{
  pkgs,
  pkgs-unstable,
  ...
}:

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
  home.stateVersion = "23.05"; # Please read the comment before changing.

  nixpkgs.config.allowUnfree = true;

  # When using Ghostty, some dead keys (such as ~ on a Swedish keyboard) don't work
  # so we need to add something like fcitx5.
  # See https://github.com/ghostty-org/ghostty/discussions/8899 for more details.
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
  };

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    curl
    discord
    file
    gcc
    gdb
    gh
    google-chrome
    htop
    jq
    meson
    ninja
    nmap
    unzip
    vlc
    vscode
    wget
  ];

  programs = {
    gpg.enable = true;
    firefox = {
      enable = true;
    };
    gh = {
      enable = true;
      settings = {
        git_protocol = "https";
        prompt = "enabled";
      };
      # gitCredentialHelper.enable = true;
    };
    ghostty = {
      enable = true;
      systemd.enable = true;
      settings = {
        theme = "";
      };
    };
    go = {
      enable = true;
      package = pkgs-unstable.pkgs.go_1_26;
      env = {
        GOPRIVATE = "github.com/einride,go.einride.tech";
        GOTOOLCHAIN = "go1.26.1+auto";
      };
    };
    vscode = {
      enable = true;
      mutableExtensionsDir = true;
      profiles = {
        default = {
          keybindings = [
            {
              key = "ctrl+0";
              command = "-workbench.action.focusSideBar";
            }
            {
              key = "ctrl+0";
              command = "workbench.action.zoomReset";
            }
            {
              key = "ctrl+shift+7";
              command = "editor.action.commentLine";
            }
            {
              key = "ctrl+alt+p";
              command = "projectManager.listProjects";
            }
          ];
        };
      };
    };
  };

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 1800;
    enableSshSupport = true;
  };

  # Add Go bin directory to $PATH
  # Add local bin directory to $PATH
  home.sessionPath = [
    "~/go/bin"
    "~/bin"
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
