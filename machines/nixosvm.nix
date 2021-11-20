{ config, pkgs, ... }:
{
  imports =
    [
      ../hardware-configuration.nix
    ];
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

  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.displayManager.gdm.wayland = false;
  services.xserver.desktopManager.gnome.enable = true;

  environment.systemPackages = with pkgs; [
    gnomeExtensions.appindicator
    gnomeExtensions.adwaita-theme-switcher
  ];

  services.udev.packages = with pkgs; [ gnome3.gnome-settings-daemon ];


  users.users.dovalperin = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;
  };

  home-manager = {
    users.dovalperin = {
      home.packages = [
        pkgs.brave
      ];
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?
}
