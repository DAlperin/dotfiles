{ pkgs, ... }:
{
  services.xserver.desktopManager.plasma5.enable = true;
  programs.qt5ct.enable = true;
}
