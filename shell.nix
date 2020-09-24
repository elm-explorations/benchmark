{ ... }:
let
  sources = import ./nix/sources.nix;
  nixpkgs = import sources.nixpkgs { };
  niv = import sources.niv { };
in with nixpkgs;
mkShell { buildInputs = [ niv.niv git nodejs nodePackages.npm ]; }
