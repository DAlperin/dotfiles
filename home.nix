{ config, pkgs, ... }:

{
  imports = [ ./modules/zsh.nix ];
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "dovalperin";
  home.homeDirectory = "/home/dovalperin";

  home.packages = [
    pkgs.yarn
    pkgs.ripgrep
    pkgs.bat
    pkgs.exa
    pkgs.rustup
  ];

  dov = {
    zsh.enable = true;
  };

  programs.home-manager.enable = true;

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.git = {
    enable = true;
    userName = "Dov Alperin";
    userEmail = "dzalperin@gmail.com";
    delta.enable = true;
    extraConfig = {
      init = {
        defaultBranch = "main";
      };
    };
  };

  programs.go = {
    enable = true;
  };

  programs.jq = {
    enable = true;
  };
}
