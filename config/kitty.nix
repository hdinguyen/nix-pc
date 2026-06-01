{ ... }:

{
  programs.kitty = {
    enable = true;
    settings = {
      enabled_layouts = "splits,stack";
      font_family = "Monaco";
      font_size = 13;
      font_features = "Monaco -calt -liga -dlig";
    };
    keybindings = {
      "super+c" = "copy_to_clipboard";
      "super+v" = "paste_from_clipboard";
      "super+t" = "new_tab";
      "super+w" = "close_window";
      "super+d" = "launch --location=vsplit";
      "super+shift+d" = "launch --location=hsplit";
    };
  };
}
