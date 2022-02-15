{ pkgs, config, ... }: {
  #Home manager configuration
  home.username = "worker";
  home.homeDirectory = "/home/dovalperin";
  imports = [ ./../../home ./../../home/nixos ];
}
