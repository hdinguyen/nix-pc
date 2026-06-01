{ pkgs, ... }:

{
  imports = [
    ./config/bash.nix
    ./config/tmux.nix
    ./config/kitty.nix
    ./config/waybar.nix
  ];

  home.username = "nguyenh";
  home.homeDirectory = "/home/nguyenh";
  home.stateVersion = "25.11";

  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/llama.cpp/build/bin"
    "$HOME/.bun/bin"
  ];
}
