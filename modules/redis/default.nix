{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.dov.redis;
in
{
  options.dov.redis.enable = mkEnableOption "redis";

  config = mkIf cfg.enable {
    services.redis.servers.default.enable = true;
  };
}
