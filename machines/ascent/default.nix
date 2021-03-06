{ config, lib, pkgs, modulesPath, nixos-hardware, ... }:

{
  imports =
    [
      (modulesPath + "/profiles/qemu-guest.nix")
    ];

  boot.initrd.availableKernelModules = [ "ahci" "xhci_pci" "virtio_pci" "sd_mod" "sr_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];
  boot.loader.grub.devices = [ "/dev/sda" ];

  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;
  boot.kernel.sysctl."net.ipv6.conf.all.forwarding" = 1;

  fileSystems."/" =
    {
      device = "/dev/sda1";
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
  sops.secrets = {
    ts_key = {
      owner = config.users.users.worker.name;
    };
    synapse_mail_host.owner = config.users.users.matrix-synapse.name;
    synapse_mail_port.owner = config.users.users.matrix-synapse.name;
    synapse_mail_user.owner = config.users.users.matrix-synapse.name;
    synapse_mail_pass.owner = config.users.users.matrix-synapse.name;
    registration_key.owner = config.users.users.matrix-synapse.name;
  };

  dov.tailscale = {
    enable = true;
    exit = "true";
  };

  dov.matrix.enable = true;
  dov.matrix.elementBase = "dov.dev";

  networking = {
    hostName = "ascent";
    domain = "matrix.dov.dev";
    firewall = {
      enable = true;
      trustedInterfaces = [ "tailscale0" ];
      allowedUDPPorts = [ config.services.tailscale.port ];
      allowedTCPPorts = [ 22 80 443 ];
    };
  };
}
