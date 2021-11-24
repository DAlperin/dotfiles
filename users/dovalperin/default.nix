{ pkgs, config, ... }:
{
  home-manager.users.dovalperin = {
    home.username = "dovalperin";
    home.homeDirectory = "/home/dovalperin";
    imports = [ ./../../home ./../../home/nixos ];
  };

  users.users.dovalperin = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = config.dov.ssh.authorizedKeys;
  };

  programs.zsh.enable = true;
}
