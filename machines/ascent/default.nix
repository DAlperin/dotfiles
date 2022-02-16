{ config, lib, pkgs, modulesPath, nixos-hardware, ... }:

{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];
  boot.kernelParams = [ "console=ttyS0,19200n8" ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 10;
  boot.loader.grub = {
    enable = true;
    version = 2;
    efiSupport = true;
    extraConfig = ''
      serial --speed=19200 --unit=0 --word=8 --parity=no --stop=1;
      terminal_input serial;
      terminal_output serial
    '';
    forceInstall = true;
    device = "nodev";
  };
  fileSystems."/" =
    {
      device = "/dev/sda";
      fsType = "ext4";
    };
  fileSystems."/boot" = {
    device = "/dev/sdd";
    fsType = "vfat";
  };

  swapDevices =
    [{ device = "/dev/sdb"; }];

  networking.usePredictableInterfaceNames = false;
  networking.hostName = "ascent";
  networking.useDHCP = false; # Disable DHCP globally as we will not need it.
  # required for ssh?
  networking.interfaces.eth0.useDHCP = true;
}
