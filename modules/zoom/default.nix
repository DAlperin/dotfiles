{ lib, config, pkgs, ... }:

with lib;

let
  cfg = config.dov.zoom;
in
{
  options.dov.zoom.enable = mkEnableOption "zoom";

  config = mkIf cfg.enable
    {
      environment.systemPackages = with pkgs; [
        unstable.zoom-us
      ];
    };
}
