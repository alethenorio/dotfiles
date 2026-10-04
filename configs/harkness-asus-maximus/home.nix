{
  pkgs,
  pkgs-unstable,
  claude-code,
  claude-desktop,
  config,
  dotfilesDir,
  lib,
  ...
}:

let
  claudeline = import ../../modules/home-manager/claudeline { inherit pkgs-unstable; };
in
{
  imports = [
    ../../modules/home-manager/git
    ../../modules/home-manager/neovim
    ../../modules/home-manager/bash
    ../../modules/home-manager/ghostty
    ../../modules/home-manager/pi-coding-agent
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
    # bitwarden-desktop is disabled because it pulls a version of electron marked as unsafe
    # bitwarden-desktop
    claude-desktop
    claudeline
    curl
    discord
    file
    gcc
    gnumake
    google-chrome
    nerd-fonts.sauce-code-pro
    nerd-fonts.fira-code
    nerd-fonts.noto
    nethogs
    nix-tree
    speedtest-cli
    udisks
  ];

  programs = {
    claude-code = {
      enable = true;
      package = claude-code;
      settings = {
        "$schema" = "https://json.schemastore.org/claude-code-settings.json";
        attribution = {
          commit = "";
          pr = "";
        };
        includeGitInstructions = false;
        enabledPlugins = { };
        extraKnownMarketplaces = {
          claude-plugins-official = {
            source = {
              source = "git";
              url = "https://github.com/anthropics/claude-plugins-official.git";
            };
          };
        };
        statusLine = {
          type = "command";
          command = "claudeline";
        };
        # model = "opus[1m]";
      };
    };
    firefox = {
      enable = true;
      # Adopt the 26.05 XDG default. The existing profile must be moved from
      # ~/.mozilla/firefox to ~/.config/mozilla/firefox (done manually, Firefox closed).
      configPath = "${config.xdg.configHome}/mozilla/firefox";
      # Without this, Firefox's own internal handler check for the
      # claude:// scheme fails ("Prevented navigation to claude://...
      # due to an unknown protocol" in the console) even though xdg-mime
      # has a valid default set — Claude Desktop's Google-login handoff
      # silently does nothing. Setting expose to false skips Firefox's
      # internal check and hands the URI straight to the OS default.
      # Status = "default" keeps it overridable in about:config.
      policies.Preferences = {
        "network.protocol-handler.expose.claude" = {
          Value = false;
          Status = "default";
        };
      };
    };
    gh = {
      enable = true;
    };
    go = {
      enable = true;
      package = pkgs.go_1_25;
    };
    plasma = {
      enable = true;
      shortcuts = {
        # Konsole and Ghostty both ship X-KDE-Shortcuts=Ctrl+Alt+T as their
        # default global shortcut; KDE's conflict resolution had silently
        # given it to Konsole. Disable Konsole's claim, and bind Ghostty's
        # explicitly (not just relying on its own default) so an explicit
        # claim always wins over any other app's default, regardless of
        # install order.
        "services/org.kde.konsole.desktop"._launch = "none";
        "services/com.mitchellh.ghostty.desktop"._launch = [
          "Ctrl+Alt+T"
          "Ctrl+Alt+T"
        ];
      };
    };
  };

  # Not using xdg.mimeApps here: it takes full ownership of mimeapps.list as
  # a read-only store symlink, which breaks apps that self-register their own
  # URL scheme handlers into that file at runtime.
  # xdg-settings only touches the "default browser" keys, leaving the rest of
  # the file writable.
  #
  # xdg-settings verifies each scheme (http, https, text/html) by reading
  # it back after writing, and under this KDE session something (most
  # likely Chrome reasserting itself) sometimes resets x-scheme-handler/http
  # back to Chrome between the write and the verification read, failing
  # that one check even though https/text-html land fine. Don't let that
  # flakiness fail the whole activation.
  home.activation.setDefaultBrowser = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    PATH="${pkgs.kdePackages.qtbase}/bin:$PATH" \
      $DRY_RUN_CMD ${pkgs.xdg-utils}/bin/xdg-settings set default-web-browser firefox.desktop || true
  '';

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.file."pi-workspace/.pi/agent/models.json".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/modules/home-manager/pi-coding-agent/models.json";
}
