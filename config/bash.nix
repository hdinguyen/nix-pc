{ pkgs, ... }:

{
  programs.bash = {
    enable = true;
    shellAliases = {
      rebuild = "sudo nixos-rebuild switch --flake /etc/nixos#nixos";
      cl = "claude --dangerously-skip-permissions --dangerously-load-development-channels server:claude-peers";
    };
    initExtra = ''
      source ${pkgs.blesh}/share/blesh/ble.sh
    '';
  };
}
