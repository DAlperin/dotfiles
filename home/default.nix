#Shared by all machines
{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    yarn
    ripgrep
    bat
    exa
    rustup
    nodejs-16_x
    nixpkgs-fmt
    lsof
    spotify
    thunderbird
    ghidra-bin
    signal-desktop
    jetbrains.idea-ultimate
    jetbrains.clion
    pencil
    niv
    dig
    gnumake
    usbutils
    evolution
    nerdfonts
    autoconf
    (hiPrio bintools)
    xclip
    wget
    tree-sitter
    exercism
    unzip
    git
    direnv
    matlab
    matlab-shell
    matlab-mlint
    matlab-mex
    git-privacy
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

  services.gpg-agent.enable = true;
  programs.gpg.enable = true;

  programs.git = {
    enable = true;
    userName = "Dov Alperin";
    userEmail = "git@dov.dev";
    delta.enable = true;
    signing = {
      key = "7F2C07B91B52BB61";
      signByDefault = true;
    };
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
