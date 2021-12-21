{ pkgs, ... }:
{
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.displayManager.gdm.wayland = false;
  services.xserver.desktopManager.gnome.enable = true;

  environment.systemPackages = with pkgs; [
    gnomeExtensions.appindicator
    gnomeExtensions.advanced-alttab-window-switcher
    gnomeExtensions.adwaita-theme-switcher
    gnomeExtensions.gtile
    gnome.gnome-tweaks
  ];

  services.udev.packages = with pkgs; [ gnome3.gnome-settings-daemon ];
}
