{ ... }:

{
  programs.kitty = {
    enable = true;
    keybindings = {
      "super+c" = "copy_to_clipboard";
      "super+v" = "paste_from_clipboard";
      "super+t" = "new_tab";
      "super+w" = "close_tab";
      "super+d" = "launch --location=hsplit";
      "super+shift+d" = "launch --location=vsplit";
    };
  };
}
