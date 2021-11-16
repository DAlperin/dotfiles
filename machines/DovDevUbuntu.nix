{ config, pkgs, ... }: {
  xdg.enable = true;
  xdg.mime.enable = true;
  targets.genericLinux.enable = true;
  programs.zsh.envExtra = ''
    if [ -e /home/dovalperin/.nix-profile/etc/profile.d/nix.sh ]; then . /home/dovalperin/.nix-profile/etc/profile.d/nix.sh; fi 
  '';
}
