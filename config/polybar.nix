{ pkgs, ... }:

{
  services.polybar = {
    enable = true;
    package = pkgs.polybar.override {
      i3Support = true;
      pulseSupport = true;
    };

    script = "polybar main &";

    settings = {
      "bar/main" = {
        width = "100%";
        height = 32;
        radius = 0;
        fixed-center = true;
        background = "#1e1e2e";
        foreground = "#cdd6f4";
        line-size = 2;
        padding-left = 1;
        padding-right = 1;
        module-margin-left = 1;
        module-margin-right = 1;
        font-0 = "JetBrainsMono Nerd Font:size=11;2";
        font-1 = "Font Awesome 6 Free:style=Solid:size=11;2";
        modules-left = "i3";
        modules-center = "title";
        modules-right = "pulseaudio date tray";
        tray-position = "right";
        tray-padding = 4;
        cursor-click = "pointer";
        dpi = 144;
      };

      "module/i3" = {
        type = "internal/i3";
        format = "<label-state> <label-mode>";
        index-sort = true;
        wrapping-scroll = false;
        label-mode = "%mode%";
        label-mode-padding = 2;
        label-mode-foreground = "#1e1e2e";
        label-mode-background = "#fab387";
        label-focused = "%name%";
        label-focused-background = "#89b4fa";
        label-focused-foreground = "#1e1e2e";
        label-focused-padding = 2;
        label-unfocused = "%name%";
        label-unfocused-foreground = "#6c7086";
        label-unfocused-padding = 2;
        label-urgent = "%name%";
        label-urgent-background = "#f38ba8";
        label-urgent-foreground = "#1e1e2e";
        label-urgent-padding = 2;
      };

      "module/title" = {
        type = "internal/xwindow";
        label = "%title:0:80:...%";
        label-foreground = "#cdd6f4";
      };

      "module/pulseaudio" = {
        type = "internal/pulseaudio";
        format-volume = "<ramp-volume> <label-volume>";
        label-volume = "%percentage%%";
        label-muted = "󰝟 muted";
        label-muted-foreground = "#6c7086";
        ramp-volume-0 = "󰕿";
        ramp-volume-1 = "󰖀";
        ramp-volume-2 = "󰕾";
        click-right = "pavucontrol";
      };

      "module/date" = {
        type = "internal/date";
        interval = 5;
        date = "%Y-%m-%d";
        time = "%H:%M";
        label = "  %time%   %date%";
        label-foreground = "#a6e3a1";
      };

      "module/tray" = {
        type = "internal/tray";
        tray-size = "70%";
        tray-padding = 4;
      };
    };
  };
}
