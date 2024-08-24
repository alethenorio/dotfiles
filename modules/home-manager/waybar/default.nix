
{ config, pkgs, lib, ...}:

{
  programs = {
    waybar = {
      enable = true;
      settings = [{
        layer = "top";
        position = "bottom";
        modules-left = [
          "sway/workspaces"
          "sway/mode"
          "custom/right-arrow-dark"
        ];
        modules-center = [
          "custom/left-arrow-dark"
          "sway/window"
          "custom/left-arrow-light"
          "custom/left-arrow-dark"
          "idle_inhibitor"
          "custom/right-arrow-dark"
        ];
        modules-right = [
          "custom/left-arrow-dark"
          "sway/language"
          "custom/left-arrow-light"
          "custom/left-arrow-dark"
          "network"
          "custom/left-arrow-light"
          "custom/left-arrow-dark"
          "cpu"
          "custom/left-arrow-light"
          "custom/left-arrow-dark"
          "memory"
          "custom/left-arrow-light"
          "custom/left-arrow-dark"
          "battery"
          "custom/left-arrow-light"
          "custom/left-arrow-dark"

          "pulseaudio"
          "custom/left-arrow-light"
          "custom/left-arrow-dark"
          "tray"
          "custom/left-arrow-light"
          "custom/left-arrow-dark"
          "clock"
          "custom/left-arrow-light"
          "custom/left-arrow-dark"
          "custom/notification"
        ];
        "custom/left-arrow-dark" = {
          format = "";
          tooltip = false;
        };
        "custom/left-arrow-light" = {
          format = "";
          tooltip = false;
        };
        "custom/right-arrow-dark" = {
          format = "";
          tooltip = false;
        };
        "custom/right-arrow-light" = {
          format = "";
          tooltip = false;
        };
        "sway/workspaces" = {
          disable-scroll = true;
          all-outputs = false;
          format = "{icon}";
        };
        "sway/mode" = {
          format = "<span style=\"italic\">{}</span>";
        };
        "tray" = {
          icon-size = 20;
          # spacing = 10;
        };
        "clock" = {
          format-alt = "{:%Y-%m-%d}";
        };
        "cpu" = {
          format = "CPU {usage:2}%";
        };
        "memory" = {
          format = "Mem {}%";
        };
        "battery" = {
          bat = "BAT0";
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{capacity}% {icon}";
          format-charging = "{capacity}% ";
          format-plugged = "{capacity}% ";
          format-icons = ["" "" "" "" ""];
        };
        "network" = {
          format-wifi = "{essid} ({signalStrength}%) ";
          format-ethernet = "{ifname}: {ipaddr}/{cidr} ";
          format-disconnected = "Disconnected ⚠";
          min-length = 30;
        };
        "pulseaudio" = {
          format = "{icon} {volume}%";
          format-bluetooth = "{volume}% {icon}";
          format-bluetooth-muted = " {icon} {format_source}";
          format-muted = "";
          format-icons = {
            headphones = "";
            handsfree = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = [""  ""];
          };
          "on-click" = "pavucontrol";
        };
        "clock" = {
          format = "{:%a %d %b %H:%M}";
        };
        "idle_inhibitor" = {
          format = "{icon}";
          format-icons = {
              activated = "";
              deactivated = "";
          };
        };
        "sway/language" = {
          format = "{short}-{variant}";
        };
        "custom/notification" = {
          tooltip = false;
          format = "{icon}";
          format-icons = {
            notification = "<span foreground='red'><sup></sup></span>" ;
            none = "" ;
            dnd-notification = "<span foreground='red'><sup></sup></span>" ;
            dnd-none = "" ;
            inhibited-notification = "<span foreground='red'><sup></sup></span>" ;
            inhibited-none = "" ;
            dnd-inhibited-notification = "<span foreground='red'><sup></sup></span>" ;
            dnd-inhibited-none = "";
          };
          return-type = "json";
          exec-if = "which swaync-client";
          exec = "swaync-client -swb";
          on-click = "swaync-client -t -sw";
          on-click-right = "swaync-client -d -sw";
          escape = true;
        };
      }];
      style = (builtins.readFile ./style.css);
    };
  };
}
