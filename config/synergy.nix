{ config, pkgs, ... }:

{
  environment.systemPackages = [ pkgs.synergy ];

  # Synergy server config — adjust screens/links to match your setup
  environment.etc."synergy.conf".text = ''
    section: screens
      nixos:
      client-hostname:
    end

    section: links
      nixos:
        right = client-hostname
      client-hostname:
        left = nixos
    end

    section: options
      heartbeat = 5000
    end
  '';

  systemd.services.synergy-server = {
    description = "Synergy Server";
    after = [ "network.target" ];
    before = [ "display-manager.service" ];
    wantedBy = [ "display-manager.service" ];
    serviceConfig = {
      ExecStart = "${pkgs.synergy}/bin/synergys --no-daemon --config /etc/synergy.conf";
      Restart = "on-failure";
      RestartSec = 3;
    };
  };

  networking.firewall.allowedTCPPorts = [ 24800 ];
}
