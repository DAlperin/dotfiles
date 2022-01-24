{ config, lib, pkgs, modulesPath, nixos-hardware, ... }:

{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];
  boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
  boot.initrd.kernelModules = [ "dm-snapshot" ];
  boot.kernelPackages = pkgs.linuxPackages_5_15;
  boot.kernelModules = [ "kvm-intel" ];
  boot.kernelParams = [ "acpi_osi=linux" ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.loader.grub = {
    enable = true;
    version = 2;
    efiSupport = true;
    enableCryptodisk = true;
    device = "nodev";
  };
  sound.enable = true;
  boot.initrd.luks.devices = {
    crypted = {
      device = "/dev/disk/by-uuid/8a5c62fa-5f27-489f-ab0c-3fc4e9aaba8b";
      preLVM = true;
    };
  };

  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/2dd147b5-4b25-4a25-85c7-07edb14a87ec";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/B97B-D41A";
      fsType = "vfat";
    };

  swapDevices =
    [{ device = "/dev/disk/by-uuid/2ed9f061-c046-431f-a7fb-5c4eb276f916"; }];

  nix =
    {
      package = pkgs.nixFlakes;
      extraOptions = ''
        experimental-features = nix-command flakes
      '';
      trustedUsers = [ "root" "dovalperin" ];
    };

  networking = {
    networkmanager.enable = true;
    networkmanager.insertNameservers = [ "1.1.1.1" "8.8.8.8" ];
    hostName = "DovDev";
    firewall = {
      enable = true;
      trustedInterfaces = [ "tailscale0" ];
      allowedUDPPorts = [ config.services.tailscale.port ];
      allowedTCPPorts = [ 22 ];
    };
  };

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  system.stateVersion = "21.11";
}
