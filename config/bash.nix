{ pkgs, ... }:

{
  programs.bash = {
    enable = true;
    shellAliases = {
      rebuild = "sudo nixos-rebuild switch --flake /etc/nixos#nixos";
      cl = "claude --dangerously-skip-permissions";
    };
    initExtra = ''
      source ${pkgs.blesh}/share/blesh/ble.sh
    '';
  };
}
