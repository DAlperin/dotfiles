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
        ((pkgs.emacsPackagesNgGen pkgs.emacsGcc).emacsWithPackages (epkgs: [
          epkgs.vterm
        ]))
        pkgs.coreutils
        pkgs.fd
        pkgs.clang-tools
        pkgs.libtool
        pkgs.ispell
        pkgs.mu
      ];
      home.file.".doom.d" = {
        source = ./doom.d;
        recursive = true;
        onChange = "~/.emacs.d/bin/doom sync";
      };
    };
}
