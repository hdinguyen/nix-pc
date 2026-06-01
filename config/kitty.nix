{ ... }:

{
  programs.kitty = {
    enable = true;
    settings = {
      enabled_layouts = "splits,stack";
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
