{ nixpkgs, compiler ? null }:
let
  inherit (nixpkgs) pkgs stdenv;
  haskellPackages = if compiler == null
                      then pkgs.haskellPackages
                      else pkgs.haskell.packages.${compiler};
  site = haskellPackages.callPackage ./site.nix {};
in stdenv.mkDerivation {
  name = "tokinanpa-website";
  buildInputs = [ site ];
  src = ./.;
  buildPhase = ''
    site build
    '';
  installPhase = ''
    mkdir $out
    cp -r _site/* $out
    '';
}
