{ modulesPath, config, pkgs, nixpkgs, ... }:
let
  website = import ./site { nixpkgs = import nixpkgs {}; };
in {
  # Import Digital Ocean droplet config
  imports = [ "${modulesPath}/virtualisation/digital-ocean-config.nix" ];

  environment.systemPackages = with pkgs; [ rsync curl ];

  nix.package = pkgs.nixFlakes;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  nix.registry.nixpkgs.flake = nixpkgs;

  # Set up Nix automatic garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
  };

  # SSH setup
  services.openssh = {
    passwordAuthentication = false;
    challengeResponseAuthentication = false;
    permitRootLogin = "no";
  };

  # Setup user to SSH into
  users.mutableUsers = false;
  users.users.kiana = {
    isNormalUser = true;
    home = "/home/kiana";
    extraGroups = [ "wheel" ];
    hashedPassword = "$6$jfBZbM5fSux8ACH6$xmt/wJClqZ.D3Hh/ttiRQS8nExJgkatyG.x0OFyrcqK2PavA5q2H1kV8ZTbWDHCpzY6d6Vp4ep.SEM0wX3xTF0";
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC0FQLsVM1bWCVNVoY9P31ByTQJKQyGdjeA4YirSb42UIX1h4+HaYk1CtzxT+AZE2GxIy1Tf5ZjCVVqoAWAilMaLkfV4kQD63D5cYnb5W/ana31Q9OI9suFEwAfnrxmzsyzq9boN2VkhMv0ZCzDDcpwRf/1mvbrnNS69pXTgIpsVgqwWynM8Ix41r9Kj2ilvWS01MGC6ybIUdnNeY2SR9za07cxlvJlflwMo1pETta0qIPTaAFym1RJyz6h1UFcF1+IGTJ6EDvJ15lGzhBNrrTdKq9VPyzEG3tD5wsDQVLBfr4HymPeyXWFnzzjFoOT7FVXq8V1HLeHOc860GLPQ4qaosudYlPt+mgvADuZqva/per3yWV0BKZTdX3rSFqbJf8XoyO1Q57vSIj7ryq9IBisA5oYGWlArndQD1ZqNzx1p/hEC60EAQRVr9DdeeWe8Fx2l67Aq9ap/Fynjmt4sJpP/82Y2Lrv0bteh4qh5i447Bqy9rBdhwuOZs0cIhDaj00= kiana"
    ];
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];

  # Nginx setup
  services.nginx.enable = true;
  services.nginx.virtualHosts."tokinanpa.dev" = {
    addSSL = true;
    enableACME = true;
    root = website;
  };
  security.acme.certs."tokinanpa.dev".email = "kiana.a.sheibani@gmail.com";

  services.do-agent.enable = true;

}
