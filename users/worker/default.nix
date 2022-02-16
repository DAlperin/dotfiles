{ pkgs, config, ... }:
{

  users.users.worker = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = config.dov.ssh.authorizedKeys;
  };

  security.sudo.extraRules = [
    { users = [ "myusername" ];
      options = [ "NOPASSWD" ];
    }
  ];

  dov = {
    #System services
    ssh.enable = true;
  };
}
