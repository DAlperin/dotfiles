# Nixos specific, does not get applied on ubuntu
{ config, pkgs, ... }: {
  #EVERYONE gets neovim. Just in case ;)
  home.packages = with pkgs; [
    unstable.neovim
  ];
}
