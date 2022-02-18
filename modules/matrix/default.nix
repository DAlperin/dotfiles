{ pkgs, config, lib, ... }:
let
  cfg = config.dov.matrix;
  fqdn =
    let
      join = hostName: domain: hostName + lib.optionalString (domain != null) ".${domain}";
    in
    join config.networking.hostName config.networking.domain;
in
{
  options.dov.matrix.enable = lib.mkEnableOption "matrix home-server";
  options.dov.matrix.elementBase = lib.mkOption {
    default = "${config.networking.domain}";
  };
  config = lib.mkIf cfg.enable {
    security.acme = {
      email = "git@dov.dev";
      acceptTerms = true;
    };
    services.postgresql.enable = true;
    services.postgresql.initialScript = pkgs.writeText "synapse-init.sql" ''
      CREATE ROLE "matrix-synapse" WITH LOGIN PASSWORD 'synapse';
      CREATE DATABASE "matrix-synapse" WITH OWNER "matrix-synapse"
        TEMPLATE template0
        LC_COLLATE = "C"
        LC_CTYPE = "C";
    '';
    services.nginx = {
      enable = true;
      # only recommendedProxySettings and recommendedGzipSettings are strictly required,
      # but the rest make sense as well
      recommendedTlsSettings = true;
      recommendedOptimisation = true;
      recommendedGzipSettings = true;
      recommendedProxySettings = true;

      virtualHosts = {
        # This host section can be placed on a different host than the rest,
        # i.e. to delegate from the host being accessible as ${config.networking.domain}
        # to another host actually running the Matrix homeserver.
        "${config.networking.domain}" = {
          enableACME = true;
          forceSSL = true;

          # Or do a redirect instead of the 404, or whatever is appropriate for you.
          # But do not put a Matrix Web client here! See the Element web section below.
          locations."/".extraConfig = ''
            return 404;
          '';

          # forward all Matrix API calls to the synapse Matrix homeserver
          locations."/_matrix" = {
            proxyPass = "http://[::1]:8008"; # without a trailing /
          };

          locations."= /.well-known/matrix/server".extraConfig =
            let
              # use 443 instead of the default 8448 port to unite
              # the client-server and server-server port for simplicity
              server = { "m.server" = "${config.networking.domain}:443"; };
            in
            ''
              add_header Content-Type application/json;
              return 200 '${builtins.toJSON server}';
            '';
          locations."= /.well-known/matrix/client".extraConfig =
            let
              client = {
                "m.homeserver" = { "base_url" = "https://${config.networking.domain}"; };
                "m.identity_server" = { "base_url" = "https://vector.im"; };
              };
              # ACAO required to allow element-web on any URL to request this json file
            in
            ''
              add_header Content-Type application/json;
              add_header Access-Control-Allow-Origin *;
              return 200 '${builtins.toJSON client}';
            '';
        };
        "chat.${cfg.elementBase}" = {
          enableACME = true;
          forceSSL = true;
          #serverAliases = [
          #  "chat.${config.networking.domain}"
          #];
          root = pkgs.element-web.override {
            conf = {
              default_server_config."m.homeserver" = {
                "base_url" = "https://${config.networking.domain}";
                "server_name" = "${config.networking.domain}";
              };
            };
          };
        };
        # Reverse proxy for Matrix client-server and server-server communication
        #${fqdn} = {
        #  enableACME = true;
        #  forceSSL = true;

        #  # Or do a redirect instead of the 404, or whatever is appropriate for you.
        #  # But do not put a Matrix Web client here! See the Element web section below.
        #  locations."/".extraConfig = ''
        #    return 404;
        #  '';

        #  # forward all Matrix API calls to the synapse Matrix homeserver
        #  locations."/_matrix" = {
        #    proxyPass = "http://[::1]:8008"; # without a trailing /
        #  };
        #};
      };
    };
    systemd.services.synapse-secrets = {
      serviceConfig.User = [ "matrix-synapse" ];
      serviceConfig.StateDirectory = "extra_synapse_configs";
      serviceConfig.StateDirectoryMode = "0750";
      after = [ "network.target" "postgresql.service" ];
      before = [ "matrix-synapse.service" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig.Type = "oneshot";
      script = ''
        echo "mail:
          smtp_host: $(cat /run/secrets/synapse_mail_host)
          smtp_port: $(cat /run/secrets/synapse_mail_port)
          smtp_user: $(cat /run/secrets/synapse_mail_user)
          smtp_pass: $(cat /run/secrets/synapse_mail_pass)
        registration_shared_secret: $(cat /run/secrets/registration_key)" > /var/lib/extra_synapse_configs/mail.yaml

      '';
    };
    services.matrix-synapse = {
      enable = true;
      server_name = config.networking.domain;
      extraConfigFiles = [ "/var/lib/extra_synapse_configs/mail.yaml" ];
      listeners = [
        {
          port = 8008;
          bind_address = "::1";
          type = "http";
          tls = false;
          x_forwarded = true;
          resources = [
            {
              names = [ "client" "federation" ];
              compress = false;
            }
          ];
        }
      ];
    };
  };
}
