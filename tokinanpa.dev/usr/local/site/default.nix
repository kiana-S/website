{ nixpkgs, compiler ? "default" }:
let
  inherit (nixpkgs) pkgs;
  haskellPackages = if compiler == "default"
                       then pkgs.haskellPackages
                       else pkgs.haskell.packages.${compiler};
  site = haskellPackages.callPackage ./site.nix {};
in
nixpkgs.stdenv.mkDerivation {
  name = "tokinanpa-website";
  buildInputs = [ site ];
  src = ./.;
  buildPhase = ''
    site build
    '';
  installPhase = ''
    mkdir $out
    install _site/* $out
    '';
}
