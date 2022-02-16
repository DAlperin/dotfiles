{ config, lib, pkgs, modulesPath, nixos-hardware, ... }:

{
  imports =
    [ (modulesPath + "/profiles/qemu-guest.nix")
    ];

  boot.initrd.availableKernelModules = [ "ahci" "xhci_pci" "virtio_pci" "sd_mod" "sr_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];
  boot.loader.grub.devices = [ "/dev/sda" ];

  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;
  boot.kernel.sysctl."net.ipv6.conf.all.forwarding" = 1;

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/b6bcf2b1-92a6-4eb8-891f-9d50e5dfa92b";
      fsType = "ext4";
    };

  swapDevices = [ ];

  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  nix =
    {
      package = pkgs.nixFlakes;
      extraOptions = ''
        experimental-features = nix-command flakes
      '';
      trustedUsers = [ "root" "worker" ];
    };
  sops.defaultSopsFile = ./secrets.yaml;
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  sops.secrets.ts_key = {
    owner = config.users.users.ascent.name;
  };
  dov.tailscale = {
    enable = true;
    exit = "true";
  };
  networking.hostName = "ascent";
}
