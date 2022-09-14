{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = inputs@{ nixpkgs, ... }: {
    nixosConfigurations.kiana-server = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        { _module.args = inputs; }
        ./config.nix
      ];
    };
  };
}
