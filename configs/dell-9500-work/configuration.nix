# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../einride/modules/nixos
    ../../modules/nixos/home-printer
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.blacklistedKernelModules = [
    "nouveau"
    "nvidia"
  ];
  boot.initrd.luks.devices."luks-83af1c6e-253f-47e3-b896-53d35cda67a8".device =
    "/dev/disk/by-uuid/83af1c6e-253f-47e3-b896-53d35cda67a8";

  hardware.graphics = {
    enable = true;
  };
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # In order to use a login manager (which needs to be done at system level),
  # we enable Sway at system level however as per https://nixos.wiki/wiki/Sway#Installation
  # the one configured at user level (through home-manager) is the one that gets used.
  programs.sway.enable = true;
  services.displayManager.ly = {
    enable = true;
  };

  # Experimental power management
  # Disable KDE default power-profiles daemon as it conflicts with auto-cpufreq
  systemd.services.power-profiles-daemon.enable = false;
  services.auto-cpufreq.enable = true;
  powerManagement.powertop.enable = true;
  services.thermald.enable = true;
  # tlp will conflict with powertop.
  # See https://linrunner.de/tlp/faq/ for details on how to configure
  #services.tlp = {
  #  enable = true;
  #  extraConfig = ''
  #    CPU_SCALING_GOVERNOR_ON_AC=performance
  #    CPU_SCALING_GOVERNOR_ON_BAT=powersave
  #  '';
  #};

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  time.timeZone = "Europe/Stockholm";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.wlp0s20f3.useDHCP = true;
  networking.networkmanager.enable = true;
  networking.hostName = "moya";

  nixpkgs.config.allowUnfree = true;

  # Necessary for Chromecast to work with Chrome
  services.avahi.enable = true;

  fonts.packages = with pkgs; [
    font-awesome
    noto-fonts
    noto-fonts-emoji
    noto-fonts-extra
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
  ];

  # Pipewire config
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    alsa.support32Bit = true;
    wireplumber = {
      enable = true;
      extraConfig = {
        "monitor.bluez.properties" = {
          "bluez5.enable-sbc-xq" = true;
          "bluez5.enable-msbc" = true;
          "bluez5.enable-hw-volume" = true;
          "bluez5.roles" = [
            "hsp_hs"
            "hsp_ag"
            "hfp_hf"
            "hfp_ag"
          ];
          "bluez5.auto-connect" = [
            "hsp_hs"
            "hsp_ag"
            "hfp_hf"
            "hfp_ag"
          ];
          "device.profile" = "headset-head-uni";
        };
      };
    };
  };

  # Gnome keyring
  services.gnome.gnome-keyring = {
    enable = true;
  };

  # Allow swaylock to unlock the computer for us
  security.pam.services.swaylock = { };

  # Polkit is needed to configure Sway through home-manager
  security.polkit.enable = true;

  # Enable xdg-desktop-portal-wlr for screen sharing
  # to work in Wayland with Sway
  xdg = {
    portal = {
      wlr = {
        enable = true;
      };
      # config.sway.default = "wlr";
      # gtkUsePortal = true;
    };
  };

  programs.wireshark = {
    enable = true;
  };

  # Control screen brightness
  programs.light.enable = true;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "sv-latin1";
  };

  users.users.alethenorio = {
    isNormalUser = true;
    home = "/home/alethenorio";
    extraGroups = [
      "wheel"
      "networkmanager"
      "docker"
      "wireshark"
      "dialout"
      "plugdev"
      "adbusers"
    ];
  };

  security.sudo.extraRules = [
    {
      users = [ "alethenorio" ];
      commands = [
        {
          command = "/run/current-system/sw/bin/ls";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];

  services.udisks2.enable = true;

  services.xserver.videoDrivers = [
    # "displaylink" # This does not build because evdi is marked as marked as broken
    "modesetting"
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    exfat
    gparted
    jwt-cli
    killall
    (vim_configurable.customize {
      # Specifies the vim binary name.
      # E.g. set this to "my-vim" and you need to type "my-vim" to open this vim
      # This allows to have multiple vim packages installed (e.g. with a different set of plugins)
      name = "vim";
      vimrcConfig.customRC = ''
        syntax on
        set mouse-=a
        set backspace=indent,eol,start
      '';
      vimrcConfig.vam.knownPlugins = pkgs.vimPlugins;
      vimrcConfig.vam.pluginDictionaries = [
        {
          names = [
            "vim-sensible" # sane defaults
            # "vim-addon-nix"
          ];
          ft_regex = "^nix\$";
        }
      ];
    })
    wget
  ];

  environment.variables = {
    EDITOR = "vim";
  };

  environment.sessionVariables = { };

  environment.enableDebugInfo = true;

  # Enable docker
  virtualisation.docker.enable = true;
  virtualisation.libvirtd.enable = true;

  # Enable ARM emulation through QEMU
  # For running docker images on X86 you also need to run this locally
  # docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
  boot.binfmt.emulatedSystems = [
    "armv7l-linux"
    "aarch64-linux"
  ];

  # Support running non-nix binaries.
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # Add any missing dynamic libraries for unpackaged programs
    # here, NOT in environment.systemPackages
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  programs.adb.enable = true;
  programs.dconf.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

}