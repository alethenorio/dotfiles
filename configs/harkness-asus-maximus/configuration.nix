# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  unstable = import <nixos-unstable> {
    config = {
      allowUnfree = true;
    };
  };
in
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../personal/configs/harkness-asus-maximus/configuration.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "harkness"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  networking.interfaces.eno1.useDHCP = true;

  # Set your time zone.
  time.timeZone = "Europe/Stockholm";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "sv_SE.UTF-8";
    LC_IDENTIFICATION = "sv_SE.UTF-8";
    LC_MEASUREMENT = "sv_SE.UTF-8";
    LC_MONETARY = "sv_SE.UTF-8";
    LC_NAME = "sv_SE.UTF-8";
    LC_NUMERIC = "sv_SE.UTF-8";
    LC_PAPER = "sv_SE.UTF-8";
    LC_TELEPHONE = "sv_SE.UTF-8";
    LC_TIME = "sv_SE.UTF-8";
  };

  # Configure console
  console = {
    keyMap = "sv-latin1";
    # Configure TTY font
    earlySetup = true;
    packages = with pkgs; [ terminus_font ];
    font = "${pkgs.terminus_font}/share/consolefonts/ter-u16n.psf.gz";
  };

  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "se";
    variant = "";
  };

  # Enable OpenGL
  hardware.graphics = {
    enable = true;
  };

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {

    # Modesetting is required.
    modesetting.enable = true;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of
    # supported GPUs is at:
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
    # Only available from driver 515.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = false;

    # Enable the Nvidia settings menu,
    # accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.production;
  };

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.groups = {
    tautulli = { };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.mutableUsers = false;
  users.users = {
    alethenorio = {
      createHome = true;
      isNormalUser = true;
      description = "Alexandre";
      extraGroups = [
        "networkmanager"
        "wheel"
      ];
      hashedPassword = "$6$mZEeKCcpo$41ITgokQpFmMG5f6BQxS628Ne2YJ0aRqmpyyHXjrl9xgXFXc2XOyJlxs2zc5dCEtSXRBWLKHx0UEd4LmLGt0t.";
      packages = with pkgs; [ ];
    };
    tautulli = {
      isNormalUser = true;
      group = "tautulli";
    };
  };

  # Enable automatic login for the user.
  # services.getty.autologinUser = "alethenorio";

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    cudatoolkit
    curl
    file
    gh
    git
    neovim
    #    unstable.ollama
    unzip
  ];

  environment.variables = {
    EDITOR = "vim";
  };

  security.pam.loginLimits = [
    {
      domain = "*";
      item = "nofile";
      type = "soft";
      value = "99999";
    }
    {
      domain = "*";
      item = "nofile";
      type = "hard";
      value = "99999";
    }
  ];

  systemd.extraConfig = "DefaultLimitNOFILE=99999";

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Enable Plex
  # In order to move the existing installation to a new server you will need to move data from
  # the old server. See https://support.plex.tv/articles/201370363-move-an-install-to-another-system/
  # for more details.
  # When enabling Plex for the first time in a new machine, go to http://<machine_ip>:32400/web
  services.plex = {
    enable = true;
    openFirewall = true;
    extraScanners = [
      (pkgs.fetchFromGitHub {
        owner = "ZeroQI";
        repo = "Absolute-Series-Scanner";
        rev = "4ef18a738c6263a8b96ab6f83ae391d4550b9cc9";
        sha256 = "1lj8n77b7b3pxac4w82rcx8i60l3lxlkzm5jhkljy4apxv8nkdyr";
      })
    ];
    extraPlugins = [
      (pkgs.stdenv.mkDerivation {
        name = "Hama.bundle";
        src = pkgs.fetchFromGitHub {
          owner = "ZeroQI";
          repo = "Hama.bundle";
          rev = "c24f2e336f7891807eacef816d270d973a151826";
          sha256 = "0dlid5n6z4rvvxmvgmv70mdrh7wl0l38i3kxvzksmaj4xdqh3xkl";
        };
        buildPhase = ''
          mkdir -p $out
          cp -r . $out/
        '';
        dontInstall = true;
      })
      (pkgs.stdenv.mkDerivation {
        name = "Traktv.bundle";
        src = pkgs.fetchFromGitHub {
          owner = "trakt";
          repo = "Plex-Trakt-Scrobbler";
          rev = "aeb0bfbe62fad4b06c164f1b95581da7f35dce0b";
          sha256 = "058691ciy1c94icw91074im24a3gkc1rq9kz67cbzwb9h9ili70q";
        };
        buildPhase = ''
          mkdir -p $out
          cp -r ./Trakttv.bundle/* $out/
        '';
        dontInstall = true;
      })
    ];
    #user = "plex";
  };

  # Enable Tautulli
  services.tautulli = {
    enable = true;
    dataDir = "/var/lib/tautulli";
    configFile = "/var/lib/tautulli/config.ini";
    user = "tautulli";
    group = "tautulli";
  };

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [
    # Tautulli
    8181
  ];

  services.ollama = {
    enable = true;
    acceleration = "cuda";
    package = unstable.ollama;
  };

  system.stateVersion = "24.05"; # Did you read the comment?
}
