{ pkgs, ... }:

{
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 32;
        spacing = 4;

        modules-left = [ "i3/workspaces" ];
        modules-center = [ "i3/window" ];
        modules-right = [ "clock" "tray" ];

        "i3/workspaces" = {
          disable-scroll = true;
          all-outputs = true;
          format = "{name}";
        };

        "i3/window" = {
          max-length = 80;
        };

        clock = {
          format = "{:%H:%M  %Y-%m-%d}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        };

        tray = {
          spacing = 8;
        };
      };
    };

    style = ''
      * {
        font-family: "JetBrainsMono Nerd Font", monospace;
        font-size: 13px;
        min-height: 0;
      }

      window#waybar {
        background-color: #1e1e2e;
        color: #cdd6f4;
        border-bottom: 2px solid #313244;
      }

      #workspaces button {
        padding: 0 8px;
        background: transparent;
        color: #6c7086;
        border: none;
        border-radius: 4px;
        margin: 4px 2px;
        transition: all 0.2s ease;
      }

      #workspaces button:hover {
        background: #313244;
        color: #cdd6f4;
      }

      #workspaces button.active {
        background: #89b4fa;
        color: #1e1e2e;
        font-weight: bold;
      }

      #workspaces button.urgent {
        background: #f38ba8;
        color: #1e1e2e;
      }

      #window {
        color: #cdd6f4;
        padding: 0 8px;
      }

      #clock {
        color: #a6e3a1;
        padding: 0 12px;
      }

      #tray {
        padding: 0 8px;
      }
    '';
  };
}
