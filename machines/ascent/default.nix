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
      device = "/dev/disk/by-uuid/60e3c41f-a210-4a11-a7a5-521ccb175654";
      fsType = "ext4";
    };

  swapDevices =
    [{ device = "/dev/disk/by-uuid/57866925-49e8-45c6-848f-28df8f2693be"; }];

  boot.loader.grub.forceInstall = true;
  boot.loader.grub.device = "nodev";
  boot.loader.timeout = 10;
  networking.usePredictableInterfaceNames = false;
  networking.hostName = "ascent";
  networking.useDHCP = false; # Disable DHCP globally as we will not need it.
  # required for ssh?
  networking.interfaces.eth0.useDHCP = true;
}
