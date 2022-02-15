{ config, lib, pkgs, modulesPath, nixos-hardware, ... }:

{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];
  boot.kernelParams = [ "console=ttyS0,19200n8" ];
  boot.loader.grub.extraConfig = ''
    serial --speed=19200 --unit=0 --word=8 --parity=no --stop=1;
    terminal_input serial;
    terminal_output serial
  '';
  fileSystems."/" =
    {
      device = "/dev/disk/by-label/Nixos";
      fsType = "ext4";
    };

  swapDevices =
    [{ device = "/dev/disk/by-label/Swap"; }];

  boot.loader.grub.forceInstall = true;
  boot.loader.grub.device = "nodev";
  boot.loader.timeout = 10;
  networking.usePredictableInterfaceNames = false;
  networking.hostName = "ascent";
  networking.useDHCP = false; # Disable DHCP globally as we will not need it.
  # required for ssh?
  networking.interfaces.eth0.useDHCP = true;
}
