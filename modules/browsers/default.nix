{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.dov.browsers;
in
{
  options.dov.browsers.brave.enable = mkEnableOption "brave";
  options.dov.browsers.firefox.enable = mkEnableOption "firefox";

  config =
    {
      environment.systemPackages = lib.optionals cfg.brave.enable [ pkgs.unstable.brave ] ++ lib.optionals cfg.firefox.enable [ pkgs.firefox ];
    };
}
