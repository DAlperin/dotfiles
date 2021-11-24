{ pkgs, config, ... }:
{
  users.users.dovalperin = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = config.dov.ssh.authorizedKeys;
  };

  programs.zsh.enable = true;
}
