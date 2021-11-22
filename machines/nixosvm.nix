{ config, pkgs, modulesPath, ... }:
{
  imports =
    [
      (modulesPath + "/profiles/qemu-guest.nix")
    ];

  boot.kernelModules = [ "kvm-intel" ];

  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/0dbfa77a-6643-46d2-89fa-8d986eaba466";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/BE60-28AB";
      fsType = "vfat";
    };

  swapDevices =
    [{ device = "/dev/disk/by-uuid/3968e636-bff7-4802-8c17-3a06858fb15a"; }];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nix =
    {
      extraOptions = ''
        experimental-features = nix-command flakes
      '';
      trustedUsers = [ "root" "dovalperin" ];
    };


  networking.networkmanager.enable = true;
  networking.useDHCP = false; #global flag deprecated
  networking.interfaces.enp1s0.useDHCP = true;
  networking.hostName = "nixosvm";

  users.users.dovalperin = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = config.dov.ssh.authorizedKeys;
  };

  programs.zsh.enable = true;
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?
}
