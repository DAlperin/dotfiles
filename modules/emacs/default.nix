{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.dov.emacs;
in
{
  options.dov.emacs.enable = mkEnableOption "emacs config";

  config = mkIf cfg.enable
    {
      home.packages = [
        ((pkgs.emacsPackagesFor pkgs.emacs28NativeComp).emacsWithPackages (epkgs: [
          epkgs.vterm
        ]))
        pkgs.coreutils
        pkgs.fd
        pkgs.clang-tools
        pkgs.libtool
        pkgs.ispell
        pkgs.mu
        pkgs.pandoc
      ];

      #For emacs daemon
      #services.emacs.enable = true;
    };
}
