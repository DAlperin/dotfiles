{ pkgs, config, lib, ... }:
let
  cfg = config.dov.tailscale;
in
{

  options.dov.tailscale.enable = lib.mkEnableOption "tailscale config";
  options.dov.tailscale.exit = lib.mkOption {
    type = with lib.types; uniq string;
    default = "false";
  };

  options.dov.tailscale.useExit = lib.mkOption {
    type = with lib.types; uniq string;
    default = "false";
  };

  config = lib.mkIf cfg.enable
    {

      environment.systemPackages = with pkgs; [
        unstable.tailscale
      ];

      services.tailscale.enable = true;
      services.tailscale.package = pkgs.unstable.tailscale;

      systemd.services.tailscale-autoconnect = {
        description = "Automatic connection to Tailscale";

        # make sure tailscale is running before trying to connect to tailscale
        after = [ "network-pre.target" "tailscale.service" ];
        wants = [ "network-pre.target" "tailscale.service" ];
        wantedBy = [ "multi-user.target" ];

        # set this service as a oneshot job
        serviceConfig.Type = "oneshot";

        # have the job run this shell script
        script = with pkgs; ''
          exit=${cfg.exit}
          key=$(cat ${config.sops.secrets.ts_key.path})
          useexit=${cfg.useExit}
          # wait for tailscaled to settle
          sleep 2

          # check if we are already authenticated to tailscale
          status="$(${unstable.tailscale}/bin/tailscale status -json | ${jq}/bin/jq -r .BackendState)"
          if [ $status = "Running" ]; then # if so, then do nothing
            exit 0
          fi

          # otherwise authenticate with tailscale
          if [ $exit = true ] ; then
            echo "exit = true"
            ${unstable.tailscale}/bin/tailscale up -authkey $key --advertise-exit-node --ssh
          else
            echo "exit = false"
            if [ $useexit = true ] ; then
              ${unstable.tailscale}/bin/tailscale up -authkey $key --exit-node=100.94.16.88 --ssh
            else
              ${unstable.tailscale}/bin/tailscale up -authkey $key --reset --ssh --accept-routes
            fi
          fi
        '';
      };
    };
}
