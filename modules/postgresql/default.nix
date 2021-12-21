{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.dov.postgres;
in
{
  options.dov.postgres.enable = mkEnableOption "postgres";

  config = mkIf cfg.enable {
    services.postgresql.enable = true;
    services.postgresql.package = pkgs.postgresql_14;
    services.postgresql.authentication = lib.mkForce ''
      local all all              trust
      host  all all 127.0.0.1/32 trust
      host  all all ::1/128      trust
    '';
  };
}
