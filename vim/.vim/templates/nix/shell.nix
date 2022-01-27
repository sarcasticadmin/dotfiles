# TODO: Pin this to a specific version of nixpkgs
{ pkgs ? import <nixpkgs> {} }:

with pkgs;

mkShell {

  # Nixpkgs in include in shell
  buildInputs = [
  ];

  # Environment tweaks
  shellHook = ''
  '';
}
