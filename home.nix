{ pkgs, ... }:

{
  home.username = "nguyenh";
  home.homeDirectory = "/home/nguyenh";
  home.stateVersion = "25.11";

  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/llama.cpp/build/bin"
  ];

  programs.bash = {
    enable = true;
    shellAliases = {
      rebuild = "sudo nixos-rebuild switch --flake /etc/nixos#nixos";
      cl = "claude --dangerously-skip-permissions";
    };
  };

  programs.tmux = {
    enable = true;
    mouse = true;
    keyMode = "vi";
    baseIndex = 1;
    escapeTime = 0;
    historyLimit = 10000;
    terminal = "tmux-256color";

    extraConfig = ''
      # Enter copy mode on scroll up
      bind -n WheelUpPane if-shell -F "#{mouse_any_flag}" "send-keys -M" \
          "if -Ft= '#{pane_in_mode}' 'send-keys -M' 'copy-mode -e'"

      # Vi copy mode bindings
      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi V send-keys -X select-line
      bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
      bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel
      bind-key -T copy-mode-vi Escape send-keys -X cancel

      # Vi pane navigation
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      bind -r H resize-pane -L 5
      bind -r J resize-pane -D 5
      bind -r K resize-pane -U 5
      bind -r L resize-pane -R 5

      set -g pane-base-index 1
      set-option -g renumber-windows on
      set -ag terminal-overrides ",xterm-256color:RGB"
    '';
  };
}
