{ pkgs, config, lib, ... }:
let
  cfg = config.dov.tailscale;
in
{

  options.dov.tailscale.enable = lib.mkEnableOption "emacs config";
  options.dov.tailscale.exit = lib.mkOption {
    type = with lib.types; uniq string;
    default = "false";
  };

  config = lib.mkIf cfg.enable
    {

  environment.systemPackages = with pkgs; [
    tailscale
  ];

  services.tailscale.enable = true;

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
      # wait for tailscaled to settle
      sleep 2

      # check if we are already authenticated to tailscale
      status="$(${tailscale}/bin/tailscale status -json | ${jq}/bin/jq -r .BackendState)"
      if [ $status = "Running" ]; then # if so, then do nothing
        exit 0
      fi

      # otherwise authenticate with tailscale
      if [$exit = true] ; then
        ${tailscale}/bin/tailscale up -authkey $key --advertise-exit-node
      else
        ${tailscale}/bin/tailscale up -authkey $key
      fi
    '';
  };
    };
}
