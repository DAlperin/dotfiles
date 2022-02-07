{ pkgs, config, ... }:
{
  users.users.dovalperin = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = config.dov.ssh.authorizedKeys;
  };

  dov = {
    #System services
    postgres.enable = true;
    ssh.enable = true;
    redis.enable = true;
    #Stuff that needs system level access in some way
    browsers.brave.enable = true;
    zoom.enable = true;
  };

  virtualisation.docker.enable = true;

  programs.zsh.enable = true;
}
