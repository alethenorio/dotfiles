{
  pkgs,
  lib,
  ...
}:
let
  unstable = import <unstable> {
    config = {
      allowUnfree = true;
    };
  };
  geminiCliNodePackage = (pkgs.callPackage ../../modules/home-manager/gemini-cli/default.nix { });
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
    ../../einride/modules/home-manager
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

  # When using Ghostty, some dead keys (such as ~ on a Swedish keyboard) don't work
  # so we need to add something like fcitx5.
  # See https://github.com/ghostty-org/ghostty/discussions/8899 for more details.
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
  };

  home.packages = with pkgs; [
    bc
    binutils
    unstable.code-cursor
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
    geminiCliNodePackage."@google/gemini-cli"
    google-chrome
    (unstable.pkgs.google-cloud-sdk.withExtraComponents [
      unstable.pkgs.google-cloud-sdk.components.skaffold
      unstable.pkgs.google-cloud-sdk.components.minikube
      unstable.pkgs.google-cloud-sdk.components.kubectl
      unstable.pkgs.google-cloud-sdk.components.log-streaming
      unstable.pkgs.google-cloud-sdk.components.cloud-run-proxy
      unstable.pkgs.google-cloud-sdk.components.cloud-spanner-emulator
    ])
    gnumake
    gnupg
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
    nodejs_20
    nodePackages.node2nix
    nodePackages.cdktf-cli
    nodePackages.firebase-tools
    openssl
    patchelf
    powertop
    # (python311.withPackages (p: [
    #   grpcio
    # ]))
    (python311.withPackages (ps: with ps; [ grpcio-tools ]))
    # (python311.withPackages python-packages)
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
    xorg.xeyes
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
      yarn = super.yarn.override { nodejs = pkgs.nodejs_20; };
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
    };
    foot = {
      enable = true;
    };
    gh = {
      enable = true;
      settings = {
        aliases = {
          pc = "!jj git push -c \"all:$1\"; for c in $(jj log --no-graph -r \"$1 & mutable()\" -T \"change_id ++ '\n'\"); do echo creating PR for $c; gh pr create --draft --head $(jj bookmark list -r $c -T name) --base $(jj bookmark list -r \"heads(::$c- & bookmarks())\" -T name) --fill; done";
        };
      };
      extensions = [
        ghdependabot
      ];
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
      package = unstable.pkgs.go_1_25;
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

  home.file."bin/configure-dell-s3422dwg.sh" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      swaymsg "output 'Dell Inc. DELL S3422DWG 7PT3KK3'  resolution --custom 3440x1440 position 0 0"
      swaymsg "output 'Sharp Corporation 0x1515 Unknown'  resolution 1920x1200 position 3440 240"
    '';
  };
}
