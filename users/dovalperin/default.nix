{ pkgs, config, ... }:
{
  sops.secrets.dovalperin_pass.neededForUsers = true;

  users.users.dovalperin = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" "libvirtd" "plugdev" "dialout" ];
    shell = pkgs.zsh;
  };

  dov = {
    #System services
    postgres.enable = true;
    ssh.enable = true;
    redis.enable = true;
    #Stuff that needs system level access in some way
    browsers = {
      brave.enable = true;
      firefox.enable = true;
    };
    zoom.enable = true;
    tailscale.enable = true;
  };

  programs.steam.enable = true;
  programs._1password-gui.enable = true;
  programs._1password-gui.gid = 5000;
  programs._1password-gui.polkitPolicyOwners = [ "dovalperin" ];

  virtualisation.docker.enable = true;
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="5740", MODE="0664", GROUP="plugdev"
  '';

  programs.zsh.enable = true;
}
