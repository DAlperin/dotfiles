{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.dov.postgres;
in
{
  options.dov.postgres.enable = mkEnableOption "postgres";
  options.dov.postgres.initialScript = {
    enabled = lib.mkOption {
      default = false;
    };
    script = lib.mkOption {
      type = with lib.types; uniq string;
      default = null;
    };
  };

  config = mkIf cfg.enable {
    services.postgresql.enable = true;
    services.postgresql.package = pkgs.postgresql_14;
    services.postgresql.settings = {
      max_connections = 200;
    };
    services.postgresql.authentication = lib.mkForce ''
      local all all              trust
      host  all all 127.0.0.1/32 trust
      host  all all ::1/128      trust
    '';
    services.postgresql.initialScript = if cfg.initialScript.enabled then cfg.inititalScript.script else null;
  };
}
