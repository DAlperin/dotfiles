#Shared by all machines
{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    ripgrep
    nixpkgs-fmt
    gnumake
    autoconf
    (hiPrio bintools)
    wget
    unzip
    git
  ];
}
