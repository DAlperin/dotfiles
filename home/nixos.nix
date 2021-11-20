# Nixos specific, does not get applied on ubuntu
{ config, pkgs, ... }: {
  imports = [
    ./home.nix
  ];

  home.packages = with pkgs; [
    brave
    neovim
    _1password-gui
  ];
  
  programs.vscode.enable = true;
}
