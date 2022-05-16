{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.programs._1password-gui;

in
{
  options = {
    programs._1password-gui = {
      enable = mkEnableOption "The 1Password Desktop application with browser integration";

      groupId = mkOption {
        type = types.int;
        example = literalExpression "5000";
        description = ''
          The GroupID to assign to the onepassword group, which is needed for browser integration. The group ID must be 1000 or greater.
        '';
      };

      opPackage = mkOption {
        type = types.package;
        default = pkgs._1password;
        defaultText = literalExpression "pkgs._1password";
        example = literalExpression "pkgs._1password";
        description = ''
          The 1Password cli derivation to use. This can be used to upgrade from the stable release that we keep in nixpkgs to the betas.
        '';
      };

      package = mkOption {
        type = types.package;
        default = (pkgs._1password-gui.override ({ polkitPolicyOwners = [ "dovalperin" ]; }));
        defaultText = literalExpression "pkgs._1password-gui";
        example = literalExpression "pkgs._1password-gui";
        description = ''
          The 1Password derivation to use. This can be used to upgrade from the stable release that we keep in nixpkgs to the betas.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    users.groups.onepassword.gid = cfg.groupId;

    security.wrappers = {
      "1Password-BrowserSupport" =
        {
          source = "${cfg.package}/share/1password/1Password-BrowserSupport";
          owner = "root";
          group = "onepassword";
          setuid = false;
          setgid = true;
        };

      "1Password-KeyringHelper" =
        {
          source = "${cfg.package}/share/1password/1Password-KeyringHelper";
          owner = "root";
          group = "onepassword";
          setuid = true;
          setgid = true;
        };
    };

  };
}
