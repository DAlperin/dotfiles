{ pkgs, config, ... }:
{

  users.users.worker = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = config.dov.ssh.authorizedKeys;
  };

  dov = {
    #System services
    ssh.enable = true;
  };
}
