{ config, pkgs, lib, ...}:

{
  services = {
    swaync = {
      enable = true;
      settings = {
        notification-visibility = {
          slack = {
            app-name = "Slack";
            state = "transient";
          };
        };
        widget-config = {
          mpris = {
            image-size = 96;
            blur = true;
          };
        };
      };
    };
  };

  home.packages = with pkgs; [
    grim
    jq
    kanshi
    slurp
    pamixer
    swayidle
    swaylock
    waybar
    wdisplays
    wf-recorder
    wl-clipboard
    wl-mirror
    wofi
  ];

  programs = {  
    wofi = {
      enable = true;
      settings = {
      };
    };
  };


  wayland.windowManager.sway = {
    enable = true;
    config =
    let
      gengifpath = "~/bin/gengif.sh";
    in {
      modifier = "Mod4";
      terminal = "alacritty";
      # terminal = "foot";
      menu = "wofi --show drun -i | xargs swaymsg exec --";
      fonts = {
        names = [ "pango:monospace" ];
        size = 8.0;
      };
      input = {
        "type:keyboard" = {
          xkb_layout = "se,us";
          xkb_variant = ",dvp";
          xkb_options = "grp:alt_shift_toggle,ctrl:nocaps";
        };
        "type:touchpad" = {
          dwt = "enabled";
          # tap = "enabled";
          click_method = "clickfinger";
          scroll_method = "two_finger";
          # accel_profile = "adaptive";
          pointer_accel = "0.5";
        };
        "type:pointer" = {
          accel_profile = "adaptive";
          pointer_accel = "0.5";
        };
      };
      bars = [{
        position = "bottom";
        command = "waybar";
        statusCommand = "while date +'%Y-%m-%d %l:%M:%S %p'; do sleep 1; done";
        fonts = {
          names = [ "pango:monospace" ];
          size = 12.0;
        };
      }];
      startup = [
        { command = "slack"; }
        # { command = "swayidle -w timeout 300 'swaymsg \"output * dpms off\"' resume 'swaymsg \"output * dpms on\"' timeout 360 'swaylock -f -c 000000' before-sleep 'swaylock -f -c 000000'"; }
        { command = "swayidle -w timeout 300 'grim -o \"$(swaymsg -t get_outputs | jq -r \".[] | select(.focused) | .name\")\" - | convert - -filter Gaussian -resize 25% -define filter:sigma=2.5 -resize 500% /tmp/lock.png && swaymsg \"output * dpms off\"' resume 'swaymsg \"output * dpms on\"' timeout 360 'swaylock -f -i /tmp/lock.png' before-sleep 'swaylock -f -i /tmp/lock.png'"; }
        { command = "swaync"; }
      ];
      #output = {
      #  HEADLESS-1 = {
      #    resolution = "1920x1080";
      #    bg = "#220900 solid_color";
      #  };
      #};
      assigns = {
        "4" = [{ class = "Slack"; }];
      };
      # workspaceOutputAssign = [
      #   { output = "HEADLESS-1"; workspace = "0"; }
      # ];
      floating = {
        criteria = [
          # { "title" = "Firefox — Sharing Indicator"; }
          { "title" = "Picture in picture"; } # Google Meet PiP window
          { "title" = "Extension: \\\(Bitwarden - Free Password Manager\\\) - Bitwarden — Mozilla Firefox"; } # Bitwarden Passkey popup
        ];
      };
      window = {
        commands = [
          {
            command = "kill";
            criteria = { title = "Firefox — Sharing Indicator"; };
          }
          {
            command = "resize set width 30 ppt";
            criteria = { title = "Extension: \\\(Bitwarden - Free Password Manager\\\) - Bitwarden — Mozilla Firefox"; };
          }
        ];
      };
      keybindings =
      let
        modifier = config.wayland.windowManager.sway.config.modifier;
      in lib.mkOptionDefault {
        "${modifier}+Tab" = "workspace back_and_forth";
        "mod1+Tab" = "workspace back_and_forth";
        "${modifier}+Ctrl+Left" = "workspace prev_on_output";
        "${modifier}+Ctrl+Right" = "workspace next_on_output";
        "${modifier}+mod1+Left" = "move workspace to output left";
        "${modifier}+mod1+Right" = "move workspace to output right";
        "${modifier}+mod1+Up" = "move workspace to output up";
        "${modifier}+mod1+Down" = "move workspace to output down";
        "${modifier}+Shift+g" = "mode gifrecorder; exec ${gengifpath} \"$(slurp)\"";
        "--locked XF86AudioRaiseVolume" = "exec --no-startup-id pamixer -i 5";
        "--locked XF86AudioLowerVolume" = "exec --no-startup-id pamixer -d 5";
        "--locked XF86AudioMute" = "exec --no-startup-id pamixer -t";
        "XF86MonBrightnessUp" = "exec sudo light -A 10";
        "XF86MonBrightnessDown" = "exec sudo light -U 10";
        # Screenshot the current focused monitor
        "--release Print" =  "exec 'grim -o \"$(swaymsg -t get_outputs | jq -r \".[] | select(.focused) | .name\")\" \"/home/alethenorio/pictures/screenshots/$(date +%d%m%Y_%H%M_%s).png\" && xdg-open \"/home/alethenorio/pictures/screenshots/$(date +%d%m%Y_%H%M_%s).png\"'";
        # Select part of the screen with the mouse to take a screenshot directly to the clipboard
        "--release Ctrl+Shift+Print" = "exec 'grim -g \"$(slurp)\" - | wl-copy -n -t \"image/png\"'";
        # Select part of the screen with the mouse to take a screenshot
        "--release Shift+Print" = "exec 'grim -g \"$(slurp)\" \"/home/alethenorio/pictures/screenshots/$(date +%d%m%Y_%H%M_%s).png\"'";
        "${modifier}+l" = "exec 'grim -o \"$(swaymsg -t get_outputs | jq -r \".[] | select(.focused) | .name\")\" - | convert - -filter Gaussian -resize 25% -define filter:sigma=2.5 -resize 500% /tmp/lock.png && swaylock -f -i /tmp/lock.png'";
        "${modifier}+0" = "workspace number 0";
        "${modifier}+Shift+0" = "move container to workspace number 0";
        "${modifier}+asterisk" = "workspace number 0";
        "${modifier}+parenleft" = "workspace number 1";
        "${modifier}+parenright" = "workspace number 2";
        "${modifier}+braceright" = "workspace number 3";
        "${modifier}+plus" = "workspace number 4";
        "${modifier}+braceleft" = "workspace number 5";
        "${modifier}+bracketright" = "workspace number 6";
        "${modifier}+bracketleft" = "workspace number 7";
        "${modifier}+exclam" = "workspace number 8";
        "${modifier}+equal" = "workspace number 9";
      };
      modes =
      let
        modifier = config.wayland.windowManager.sway.config.modifier;
      in {
        gifrecorder = {
          # "Escape" = "exec 'kill -SIGHUP \"$(ps -eo pid,args | grep 'gengif'|grep -v grep|cut -d' ' -f3)\"'; mode default";
          "${modifier}+Shift+g" = "exec 'kill -s INT \"$(pgrep -f ${gengifpath})\"'; mode default";
        };
      };
    };
  };
}
