# Nixos specific, does not get applied on ubuntu
{ config, pkgs, ... }: {
  home.packages = with pkgs; [
    brave
    neovim
    element-desktop
    discord
  ];

  programs.vscode.enable = true;
}
