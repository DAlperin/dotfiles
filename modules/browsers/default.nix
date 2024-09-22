{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.dov.browsers;
in
{
  options.dov.browsers.brave.enable = mkEnableOption "brave";
  options.dov.browsers.firefox.enable = mkEnableOption "firefox";
  options.dov.browsers.chrome.enable = mkEnableOption "chrome";

  config =
    {
      environment.systemPackages = lib.optionals cfg.brave.enable [ pkgs.unstable.brave ] ++ lib.optionals cfg.firefox.enable [ pkgs.firefox ] ++ lib.optionals cfg.chrome.enable [ pkgs.google-chrome ];
    };
}
