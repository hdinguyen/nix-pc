{ pkgs, lib, ... }:

{
  imports = [
    ./config/bash.nix
    ./config/tmux.nix
    ./config/kitty.nix
    ./config/waybar.nix
    ./config/i3.nix
  ];

  home.username = "nguyenh";
  home.homeDirectory = "/home/nguyenh";
  home.stateVersion = "25.11";

  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/llama.cpp/build/bin"
  ];

  home.activation.bunNodeSymlink = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    ln -sf "${pkgs.bun}/bin/bun" "$HOME/.local/bin/node"
  '';

  home.file.".pi/agent/models.json".text = builtins.toJSON {
    providers = {
      llama-cpp = {
        baseUrl = "http://localhost:8080/v1";
        api = "openai-completions";
        apiKey = "none";
        compat = {
          supportsDeveloperRole = false;
          supportsReasoningEffort = false;
          supportsUsageInStreaming = false;
        };
        models = [
          {
            id = "local";
            name = "llama.cpp local";
            contextWindow = 32768;
            maxTokens = 8192;
            cost = { input = 0; output = 0; cacheRead = 0; cacheWrite = 0; };
          }
        ];
      };
    };
  };
}
