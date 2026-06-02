{ config, lib, pkgs, pkgs-unstable, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./config/synergy.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.configurationLimit = 2;
  

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "nixos"; 

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Ho_Chi_Minh";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-bamboo
      fcitx5-gtk
    ];
  };

  # Enable flatpak
  services.flatpak.enable = true;
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  xdg.portal.config.common.default = "*";

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.xkb.layout = "us";
  services.xserver.windowManager.i3.enable = true;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # services.pulseaudio.enable = true;
  # OR
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.nguyenh = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" ]; # Enable ‘sudo’ for the user.
    initialPassword = "changeme";
    packages = with pkgs; [
      tree
    ];
  };
 
  hardware.nvidia = {
    open = true;
    modesetting.enable = true;
    powerManagement.enable = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  }; 
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      nvidia-vaapi-driver
    ];
  };

  boot.kernelParams = ["nvidia-drm.modeset=1"];

  services.xserver.videoDrivers = ["nvidia"];
  
  nixpkgs.config.allowUnfree = true;
 
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  environment.sessionVariables = {
    LD_LIBRARY_PATH = lib.mkForce (lib.concatStringsSep ":" [
      "/run/opengl-driver/lib"
      "${pkgs.cudaPackages.cuda_cudart}/lib"
      "${pkgs.cudaPackages.libcublas}/lib"
    ]);
    HF_HUB_CACHE = "$HOME/models";
  };

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = false;
  };

  services.displayManager.defaultSession = "none+i3";

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc.lib
      zlib
      openssl
      curl
      glibc
      cudaPackages.cuda_cudart
      cudaPackages.libcublas
      libGL
      alsa-lib
    ];
  };

  # programs.firefox.enable = true;

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  fonts.packages = with pkgs; [
    font-awesome
    nerd-fonts.jetbrains-mono
    (pkgs.runCommand "monaco-font" {} ''
      mkdir -p $out/share/fonts/truetype
      cp ${./fonts/Monaco.ttf} $out/share/fonts/truetype/Monaco.ttf
    '')
  ];

  services.udev.packages = [ pkgs.usb-modeswitch-data ];
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="0bda", ATTR{idProduct}=="1a2b", RUN+="${pkgs.usb-modeswitch}/bin/usb_modeswitch -K -v 0bda -p 1a2b"
  '';

  environment.systemPackages = with pkgs; [
    usb-modeswitch
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    curl
    git
    kitty
    waybar
    rofi
    networkmanagerapplet
    brave
    tmux
    python3Packages.huggingface-hub
    uv
    jq
    bun
    pnpm
    arandr
    adwaita-icon-theme
    flameshot
    picom
    feh
    gthumb
    # llama.cpp build dependencies
    cmake
    ninja
    pkg-config
    cudaPackages.cuda_nvcc
    cudaPackages.cuda_cudart
    cudaPackages.cuda_cccl
    cudaPackages.libcublas
    blueman
  ];

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      Policy.AutoEnable = true;
    };
  };
  services.blueman.enable = true;

  systemd.services.bluetooth-usb-reset = {
    description = "Reset USB Bluetooth adapter at boot";
    after = [ "bluetooth.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "bt-usb-reset" ''
        for dev in /sys/bus/usb/devices/*; do
          if [ -f "$dev/idVendor" ] && [ "$(cat $dev/idVendor 2>/dev/null)" = "0bda" ]; then
            echo 0 > "$dev/authorized" && sleep 1 && echo 1 > "$dev/authorized"
          fi
        done
      '';
      RemainAfterExit = true;
    };
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  services.cloudflare-warp = {
    enable = true;
    package = pkgs-unstable.cloudflare-warp;
  };

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 8080 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.11"; # Did you read the comment?

}

