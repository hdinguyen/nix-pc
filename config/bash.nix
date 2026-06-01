{ ... }:

{
  programs.bash = {
    enable = true;
    shellAliases = {
      rebuild = "sudo nixos-rebuild switch --flake /etc/nixos#nixos";
      cl = "claude --dangerously-skip-permissions";
    };
  };
}
