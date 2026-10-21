{
  pkgs,
  pkgs-unstable,
  gws,
  gws-src,
  claude-desktop,
  config,
  lib,
  dotfilesDir,
  ...
}:
let
  # gwsSkillsPath = "${gws-src}/skills";
  # gwsSkillLinks = lib.mapAttrs' (name: _: {
  #   name = ".claude/skills/${name}";
  #   value = { source = "${gwsSkillsPath}/${name}"; };
  # }) (lib.filterAttrs (_: type: type == "directory") (builtins.readDir gwsSkillsPath));

  ghdependabot = pkgs.buildGoModule rec {
    pname = "gh-dependabot";
    version = "0.14.0";

    src = pkgs.fetchFromGitHub {
      owner = "einride";
      repo = "gh-dependabot";
      rev = "v0.14.0";
      hash = "sha256-JeM0JV8me7ZK0xqayu2bGIdxL30EQ/mYFNR5uWjqD7w=";
    };

    # buildGoModule tries to build every single module by default.
    # We only want to build the root module.
    subPackages = ".";

    vendorHash = "sha256-lG7Dqkq2y5uc/xTQDLkTyrNSIlbogSYlbk2wrCTcwpc=";

    ldflags = [
      "-s"
      # "-w"
    ];
  };
in
{
  imports = [
    ../../modules/home-manager/git
    ../../modules/home-manager/neovim
    ../../modules/home-manager/sway
    ../../modules/home-manager/waybar
    ../../modules/home-manager/bash
    ../../modules/home-manager/ghostty
    ../../einride/modules/home-manager
    ../../modules/home-manager/pi-coding-agent
  ];
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "alethenorio";
  home.homeDirectory = "/home/alethenorio";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each releas<e.
  home.stateVersion = "24.11";

  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1"; # enable wayland support in firefox
    #  XDG_CURRENT_DESKTOP = "sway";
    #  _JAVA_AWT_WM_NONREPARENTING = "1";
    WLR_NO_HARDWARE_CURSORS = "1";
    # TODO: Enable Ozone Electron support when VS Code does not break keybindings.
    # See https://github.com/microsoft/vscode/issues/127932 for details
    # NIXOS_OZONE_WL="1";
  };

  # Add Go bin directory to $PATH
  # Add local bin directory to $PATH
  home.sessionPath = [
    "~/go/bin"
    "~/bin"
  ];

  nixpkgs.config.allowUnfree = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.mise = {
    enable = true;
    enableBashIntegration = true;
    package = pkgs-unstable.mise;
    # gh keeps its token in the keyring, which mise's own gh token lookup
    # (github.gh_cli_tokens) cannot read, so ask gh for it instead.
    globalConfig.settings.github.credential_command = "gh auth token";
  };

  home.packages = with pkgs; [
    age
    bc
    binutils
    claude-desktop
    pkgs-unstable.code-cursor
    curl
    dejavu_fonts
    dig
    docker-buildx # docker buildx feature
    envsubst
    ethtool
    file
    ffmpeg
    font-awesome
    fontconfig
    gcc
    gh
    gimp
    git
    google-chrome
    # TODO: switch back to pkgs-unstable once NixOS/nixpkgs#527528 is merged.
    # 570.0.0 in unstable pulls in bundled-python3 via withExtraComponents which
    # fails auto-patchelf; the stable version (548.0.0) is unaffected.
    (pkgs.google-cloud-sdk.withExtraComponents [
      pkgs.google-cloud-sdk.components.skaffold
      pkgs.google-cloud-sdk.components.minikube
      pkgs.google-cloud-sdk.components.kubectl
      pkgs.google-cloud-sdk.components.log-streaming
      pkgs.google-cloud-sdk.components.cloud-run-proxy
      pkgs.google-cloud-sdk.components.cloud-spanner-emulator
    ])
    gws
    gnumake
    gnupg
    gopass
    graphviz
    hwinfo
    htop
    imagemagick
    inkscape
    jq
    ko
    logiops
    nerd-fonts.sauce-code-pro
    nerd-fonts.fira-code
    nerd-fonts.noto
    netcat-gnu
    nethogs
    nix-tree
    nmap
    nodejs_22
    firebase-tools
    openssl
    patchelf
    powertop
    qimgv
    slack
    speedtest-cli
    tio # Serial console TTY
    udisks
    unzip
    upower
    usbutils
    vlc
    vscode
    wget
    wireshark
    xdg-utils
    xeyes
    xxd
    yarn

    # handmade penguim
    gdb
    meson
    ninja
  ];

  fonts.fontconfig.enable = true;

  nixpkgs.overlays = [
    (self: super: {
      # Better support for wayland in Slack
      slack = super.slack.overrideAttrs (old: {
        installPhase = old.installPhase + ''
          rm $out/bin/slack

          makeWrapper $out/lib/slack/slack $out/bin/slack \
          --prefix XDG_DATA_DIRS : $GSETTINGS_SCHEMAS_PATH \
          --prefix PATH : ${lib.makeBinPath [ pkgs.xdg-utils ]} \
          --prefix NIXOS_OZONE_WL : "1" \
          --add-flags "--enable-features=WebRTCPipeWireCapturer %U"
        '';
      });
      yarn = super.yarn.override { nodejs = pkgs.nodejs_22; };
    })
  ];

  xdg.desktopEntries = {
    cursor = {
      name = "Cursor (Wayland)";
      genericName = "Cursor";
      exec = "cursor --ozone-platform=wayland";
    };
  };

  programs = {
    # Machine-specific override on top of the shared einride settings.
    claude-code.settings.preferredNotifChannel = "notifications_disabled";
    alacritty = {
      enable = true;
      settings = {
        selection = {
          save_to_clipboard = true;
        };
        scrolling = {
          history = 100000;
        };
      };
    };
    firefox = {
      enable = true;
      # Adopt the 26.05 XDG default. The existing profile must be moved from
      # ~/.mozilla/firefox to ~/.config/mozilla/firefox (done manually, Firefox closed).
      configPath = "${config.xdg.configHome}/mozilla/firefox";
      # Keep Firefox's memory footprint down. Set via enterprise policy so all
      # profiles are covered without home-manager taking over profiles.ini.
      # Status = "default" keeps the prefs overridable in about:config.
      policies.Preferences = {
        # Cap regular (non-isolated) web content processes (default 8).
        "dom.ipc.processCount" = {
          Value = 4;
          Status = "default";
        };
        # Pages kept alive in memory for back/forward navigation; the default
        # scales with RAM (8 at 30G).
        "browser.sessionhistory.max_total_viewers" = {
          Value = 2;
          Status = "default";
        };
        # Cap the in-memory cache at 256 MiB instead of RAM-scaled auto sizing.
        "browser.cache.memory.capacity" = {
          Value = 262144;
          Status = "default";
        };
        # Unload background tabs under memory pressure (default on Linux since
        # Firefox 121; set explicitly so it survives default changes).
        "browser.tabs.unloadOnLowMemory" = {
          Value = true;
          Status = "default";
        };
        # Without this, Firefox's own internal handler check for the
        # claude:// scheme fails ("Prevented navigation to claude://...
        # due to an unknown protocol" in the console) even though xdg-mime
        # has a valid default set — Claude Desktop's Google-login handoff
        # silently does nothing. Setting expose to false skips Firefox's
        # internal check and hands the URI straight to the OS default.
        "network.protocol-handler.expose.claude" = {
          Value = false;
          Status = "default";
        };
      };
    };
    foot = {
      enable = true;
    };
    gh = {
      enable = true;
      settings = {
        aliases = {
          pc = "!jj git push -c \"$1\" || exit 1; for c in $(jj log --no-graph -r \"$1 & mutable()\" -T \"change_id ++ '\n'\"); do echo creating PR for $c; gh pr create --draft --head \"$(jj bookmark list -r $c -T name)\" --base \"$(jj bookmark list -r \"heads(::$c- & bookmarks())\" -T name)\" --fill; done";
        };
      };
      extensions = [
        ghdependabot
      ];
    };
    go = {
      enable = true;
      package = pkgs-unstable.go_1_27;
      env = {
        GOPRIVATE = "github.com/einride,go.einride.tech";
        GOTOOLCHAIN = "go1.25.5+auto";
      };
    };
    java = {
      enable = true;
    };
    # password store is required to get pass secret keyring to work
    # See https://inconclusive.medium.com/sharing-passwords-with-git-gpg-and-pass-628c2db2a9de for initialization
    password-store = {
      enable = true;
      # Adopt the 26.05 default (no PASSWORD_STORE_DIR override -> pass uses
      # ~/.password-store). No existing store on disk, so nothing to migrate.
      settings = { };
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

  # home.file = gwsSkillLinks // {
  home.file = { } // {
    "bin/configure-dell-s3422dwg.sh" = {
      executable = true;
      text = ''
        #!/usr/bin/env bash
        swaymsg "output 'Dell Inc. DELL S3422DWG 7PT3KK3'  resolution --custom 3440x1440 position 0 0"
        swaymsg "output 'Sharp Corporation 0x1515 Unknown'  resolution 1920x1200 position 3440 240"
      '';
    };
    ".pi/agent/AGENTS.md".source =
      config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/modules/home-manager/pi-coding-agent/CODING_AGENTS.md";
  };

}
