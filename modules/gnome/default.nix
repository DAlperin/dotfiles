{ pkgs, ... }:
{
  services.xserver.desktopManager.gnome.enable = true;

  # https://github.com/NixOS/nixpkgs/issues/75867
  programs.ssh.askPassword = pkgs.lib.mkForce "${pkgs.gnome.seahorse.out}/libexec/seahorse/ssh-askpass";

  environment.systemPackages = with pkgs; [
    gnomeExtensions.appindicator
    gnomeExtensions.advanced-alttab-window-switcher
    gnomeExtensions.adwaita-theme-switcher
    gnomeExtensions.gtile
    gnome.gnome-tweaks
    wmctrl
    gnvim
    adwaita-qt
    libsForQt5.qtstyleplugins
  ];

  qt = {
    enable = true;
    platformTheme = "gnome";
    style = "adwaita-dark";
  };

  services.udev.packages = with pkgs; [ gnome3.gnome-settings-daemon ];
}
