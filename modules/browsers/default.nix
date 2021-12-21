{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.dov.browsers;
in
{
  options.dov.browsers.brave.enable = mkEnableOption "brave";

  config = mkIf cfg.brave.enable
    {
      environment.systemPackages = with pkgs; [
        brave
      ];
    };
}
