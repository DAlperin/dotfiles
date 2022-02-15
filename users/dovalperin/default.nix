{ pkgs, config, ... }:
{
  sops.secrets.dovalperin_pass.neededForUsers = true;

  users.users.dovalperin = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" "libvirtd" ];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = config.dov.ssh.authorizedKeys;
    passwordFile = config.sops.secrets.dovalperin_pass.path;
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

  sops.age.keyFile = "/home/dovalperin/.config/sops/age/keys.txt";
  sops.age.sshKeyPaths = [ ];
  sops.secrets = {
    ts_key = {
      owner = config.users.users.dovalperin.name;
    };
    gh_packages_key = {
      owner = config.users.users.dovalperin.name;
    };
    pia_auth = {
      owner = config.users.users.dovalperin.name;
    };
  };
}
