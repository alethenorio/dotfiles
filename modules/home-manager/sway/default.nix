{
  config,
  pkgs,
  lib,
  ...
}:

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
    pavucontrol
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
        width = 600;
        height = 400;
        location = "center";
        show = "drun";
        prompt = "Search...";
        filter_rate = 100;
        allow_markup = true;
        no_actions = true;
        halign = "fill";
        orientation = "vertical";
        content_halign = "fill";
        insensitive = true;
        allow_images = true;
        image_size = 24;
        columns = 1;
      };
      style = ''
        /* Catppuccin Mocha palette */
        @define-color base #1e1e2e;
        @define-color mantle #181825;
        @define-color crust #11111b;
        @define-color surface0 #313244;
        @define-color surface1 #45475a;
        @define-color surface2 #585b70;
        @define-color text #cdd6f4;
        @define-color subtext0 #a6adc8;
        @define-color subtext1 #bac2de;
        @define-color blue #89b4fa;
        @define-color lavender #b4befe;
        @define-color sapphire #74c7ec;
        @define-color mauve #cba6f7;
        @define-color overlay0 #6c7086;

        * {
          font-family: "monospace";
          font-size: 14px;
        }

        window {
          margin: 0px;
          border: 2px solid @surface2;
          border-radius: 12px;
          background-color: @base;
        }

        #input {
          padding: 10px 16px;
          margin: 8px;
          border: none;
          border-radius: 8px;
          color: @text;
          background-color: @surface0;
          font-size: 16px;
        }

        #input:focus {
          border: 2px solid @blue;
          outline: none;
        }

        #inner-box {
          margin: 0px 8px 8px 8px;
          border: none;
          background-color: transparent;
        }

        #outer-box {
          margin: 0px;
          padding: 0px;
          border: none;
          background-color: transparent;
        }

        #scroll {
          margin: 0px;
          border: none;
        }

        #text {
          margin: 0px;
          padding: 4px 0px;
          color: @text;
        }

        #entry {
          padding: 6px 12px;
          margin: 2px 0px;
          border-radius: 8px;
          background-color: transparent;
        }

        #entry:selected {
          background-color: @surface0;
          outline: none;
        }

        #entry:selected #text {
          color: @blue;
          font-weight: bold;
        }

        #img {
          margin-right: 8px;
        }
      '';
    };
  };

  wayland.windowManager.sway = {
    enable = true;
    config =
      let
        gengifpath = "~/bin/gengif.sh";
      in
      {
        modifier = "Mod4";
        terminal = "ghostty";
        # terminal = "foot";
        menu = "wofi | xargs swaymsg exec --";
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
        bars = [
          {
            position = "bottom";
            command = "waybar";
            statusCommand = "while date +'%Y-%m-%d %l:%M:%S %p'; do sleep 1; done";
            fonts = {
              names = [ "pango:monospace" ];
              size = 12.0;
            };
          }
        ];
        startup = [
          { command = "slack"; }
          # { command = "swayidle -w timeout 300 'swaymsg \"output * dpms off\"' resume 'swaymsg \"output * dpms on\"' timeout 360 'swaylock -f -c 000000' before-sleep 'swaylock -f -c 000000'"; }
          {
            command = "swayidle -w timeout 300 'grim -o \"$(swaymsg -t get_outputs | jq -r \".[] | select(.focused) | .name\")\" - | convert - -filter Gaussian -resize 25% -define filter:sigma=2.5 -resize 500% /tmp/lock.png && swaymsg \"output * dpms off\"' resume 'swaymsg \"output * dpms on\"' timeout 360 'swaylock -f -i /tmp/lock.png' before-sleep 'swaylock -f -i /tmp/lock.png'";
          }
          # { command = "swaync"; }
        ];
        #output = {
        #  HEADLESS-1 = {
        #    resolution = "1920x1080";
        #    bg = "#220900 solid_color";
        #  };
        #};
        assigns = {
          "4" = [ { class = "Slack"; } ];
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
              criteria = {
                title = "Firefox — Sharing Indicator";
              };
            }
            {
              command = "resize set width 30 ppt";
              criteria = {
                title = "Extension: \\\(Bitwarden - Free Password Manager\\\) - Bitwarden — Mozilla Firefox";
              };
            }
          ];
        };
        keybindings =
          let
            modifier = config.wayland.windowManager.sway.config.modifier;
          in
          lib.mkOptionDefault {
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
            "--release Print" =
              "exec 'grim -o \"$(swaymsg -t get_outputs | jq -r \".[] | select(.focused) | .name\")\" \"/home/alethenorio/pictures/screenshots/$(date +%d%m%Y_%H%M_%s).png\" && xdg-open \"/home/alethenorio/pictures/screenshots/$(date +%d%m%Y_%H%M_%s).png\"'";
            # Select part of the screen with the mouse to take a screenshot directly to the clipboard
            "--release Ctrl+Shift+Print" = "exec 'grim -g \"$(slurp)\" - | wl-copy -n -t \"image/png\"'";
            # Select part of the screen with the mouse to take a screenshot
            "--release Shift+Print" =
              "exec 'grim -g \"$(slurp)\" \"/home/alethenorio/pictures/screenshots/$(date +%d%m%Y_%H%M_%s).png\"'";
            "${modifier}+l" =
              "exec 'grim -o \"$(swaymsg -t get_outputs | jq -r \".[] | select(.focused) | .name\")\" - | convert - -filter Gaussian -resize 25% -define filter:sigma=2.5 -resize 500% /tmp/lock.png && swaylock -f -i /tmp/lock.png'";
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
          in
          {
            gifrecorder = {
              # "Escape" = "exec 'kill -SIGHUP \"$(ps -eo pid,args | grep 'gengif'|grep -v grep|cut -d' ' -f3)\"'; mode default";
              "${modifier}+Shift+g" = "exec 'kill -s INT \"$(pgrep -f ${gengifpath})\"'; mode default";
            };
          };
      };
    extraConfig = ''
      primary_selection disabled
    '';
  };
}
