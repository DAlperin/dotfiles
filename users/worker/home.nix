{ pkgs, config, ... }: {
  #Home manager configuration
  home.username = "worker";
  home.homeDirectory = "/home/worker";
  imports = [ ./../../home ./../../home/nixos ];
}
