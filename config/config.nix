{ modulesPath, config, pkgs, nixpkgs, ... }:
let
  website = import ./site { nixpkgs = import nixpkgs {}; };
in {
  # Import Digital Ocean droplet config
  imports = [ "${modulesPath}/virtualisation/digital-ocean-config.nix" ];

  environment.systemPackages = with pkgs; [ rsync curl ];

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

}
