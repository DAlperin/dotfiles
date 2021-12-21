{ pkgs, config, ... }:
{
  home-manager.users.dovalperin = {
    home.username = "dovalperin";
    home.homeDirectory = "/home/dovalperin";
    imports = [ ./../../home ./../../home/nixos ];
  };

  users.users.dovalperin = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = config.dov.ssh.authorizedKeys;
  };

  dov = {
    postgres.enable = true;
    redis.enable = true;
    browsers.brave.enable = true;
    "1password".enable = true;
    ssh.enable = true;
    zoom.enable = true;
  };

  virtualisation.docker.enable = true;

  programs.zsh.enable = true;
}
