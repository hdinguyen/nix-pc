{ pkgs, ... }:

let
  modifier = "Mod4"; # Super key
  terminal = "kitty";
  menu = "rofi -show drun";
in
{
  xsession.enable = true;

  xsession.windowManager.i3 = {
    enable = true;
    config = {
      modifier = modifier;
      terminal = terminal;

      startup = [
        { command = "systemctl --user restart polybar"; notification = false; }
        { command = "fcitx5 -d"; notification = false; }
        { command = "picom -b"; notification = false; }
      ];

      keybindings = {
        "${modifier}+t"       = "exec ${terminal}";
        "${modifier}+q"       = "kill";
        "${modifier}+space"   = "exec ${menu}";
        "${modifier}+f"       = "floating toggle";
        "${modifier}+p"       = "layout toggle split";
        "${modifier}+j"       = "layout toggle split";

        "${modifier}+h"       = "focus left";
        "${modifier}+l"       = "focus right";
        "${modifier}+k"       = "focus up";
        "${modifier}+Down"    = "focus down";

        "${modifier}+Shift+h" = "move left";
        "${modifier}+Shift+l" = "move right";
        "${modifier}+Shift+k" = "move up";
        "${modifier}+Shift+j" = "move down";

        "Mod1+1" = "workspace number 1";
        "Mod1+2" = "workspace number 2";
        "Mod1+3" = "workspace number 3";
        "Mod1+4" = "workspace number 4";
        "Mod1+5" = "workspace number 5";
        "Mod1+6" = "workspace number 6";
        "Mod1+7" = "workspace number 7";
        "Mod1+8" = "workspace number 8";
        "Mod1+9" = "workspace number 9";
        "Mod1+0" = "workspace number 10";

        "Mod1+Shift+1" = "move container to workspace number 1";
        "Mod1+Shift+2" = "move container to workspace number 2";
        "Mod1+Shift+3" = "move container to workspace number 3";
        "${modifier}+Shift+4" = "exec flameshot gui";
        "Mod1+Shift+5" = "move container to workspace number 5";
        "Mod1+Shift+6" = "move container to workspace number 6";
        "Mod1+Shift+7" = "move container to workspace number 7";
        "Mod1+Shift+8" = "move container to workspace number 8";
        "Mod1+Shift+9" = "move container to workspace number 9";
        "Mod1+Shift+0" = "move container to workspace number 10";

        "XF86AudioRaiseVolume" = "exec wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+";
        "XF86AudioLowerVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
        "XF86AudioMute"        = "exec wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        "XF86AudioMicMute"     = "exec wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
        "XF86AudioNext"        = "exec playerctl next";
        "XF86AudioPause"       = "exec playerctl play-pause";
        "XF86AudioPlay"        = "exec playerctl play-pause";
        "XF86AudioPrev"        = "exec playerctl previous";

        "${modifier}+m" = "exit";

        "${modifier}+r" = "mode resize";
      };

      bars = [];  # polybar handles the bar

      window.border = 2;

      colors = {
        focused = {
          border      = "#33ccff";
          background  = "#33ccff";
          text        = "#ffffff";
          indicator   = "#00ff99";
          childBorder = "#33ccff";
        };
        unfocused = {
          border      = "#595959";
          background  = "#1e1e2e";
          text        = "#888888";
          indicator   = "#595959";
          childBorder = "#595959";
        };
      };
    };

    extraConfig = ''
      # HiDPI: set DPI to 144 (96 * 1.5 scale equivalent for 4K monitor)
      exec_always xrdb -merge <<< "Xft.dpi: 144"
      exec_always xrdb -merge <<< "Xcursor.theme: Adwaita"
      exec_always xrdb -merge <<< "Xcursor.size: 48"

      # Input method
      exec_always fcitx5 -d --replace

      # Set GTK/Qt input method env vars
      exec_always systemctl --user import-environment GTK_IM_MODULE QT_IM_MODULE XMODIFIERS
    '';
  };

  home.sessionVariables = {
    GTK_IM_MODULE = "fcitx";
    QT_IM_MODULE  = "fcitx";
    XMODIFIERS    = "@im=fcitx";
  };
}
