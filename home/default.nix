#Shared by all machines
{ config, pkgs, ... }:
{
  home.packages = [
    pkgs.yarn
    pkgs.ripgrep
    pkgs.bat
    pkgs.exa
    pkgs.rustup
    pkgs.nodejs
    pkgs.nixpkgs-fmt
    pkgs.lsof
    pkgs.spotify
    pkgs.thunderbird
    pkgs.ghidra-bin
    pkgs.signal-desktop
    pkgs.jetbrains.idea-ultimate
    pkgs.jetbrains.clion
    pkgs.pencil
    pkgs.niv
    pkgs.dig
    pkgs.gnumake
    pkgs.usbutils
    pkgs.evolution
    pkgs.nerdfonts
    pkgs.autoconf
    (pkgs.hiPrio pkgs.bintools)
    pkgs.xclip
    pkgs.wget
    pkgs.tree-sitter
    pkgs.exercism
    pkgs.unzip
    pkgs.git
    pkgs.direnv
    pkgs.matlab
    pkgs.matlab-shell
    pkgs.matlab-mlint
    pkgs.matlab-mex
  ];

  dov = {
    zsh.enable = true;
    emacs.enable = true;
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
