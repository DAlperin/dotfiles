{ pkgs, config, ... }: {
  #Home manager configuration
  home.username = "dovalperin";
  home.homeDirectory = "/home/dovalperin";
  imports = [ ./../../home ./../../home/nixos ];

  home.packages = with pkgs; [
    loc
    betaflight-configurator
    element-desktop
    discord
    yarn
    bat
    exa
    nodejs-16_x
    lsof
    spotify
    thunderbird
    signal-desktop
    dig
    nerdfonts
    (hiPrio bintools)
    xclip
    tree-sitter
    exercism
    mercurial
    wireshark
    age
    sops
    minecraft
    steam-run
    pscale
    mysql80
    gitkraken
    gcc
    flyctl
    fira-code
    libreoffice
    asciinema
    jetbrains.idea-ultimate
    postman
    insomnia
    docker-compose
    terraform
    bun
    glib
    slack
    gimp
    ghidra
    pandoc
    peek
    rustup
  ];

  dov = {
    zsh.enable = true;
    emacs.enable = true;
  };

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
#  programs.direnv.nix-direnv.enableFlakes = true;

  programs.home-manager.enable = true;

  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  services.gpg-agent.enable = true;
  programs.gpg.enable = true;

  programs.mercurial = {
    enable = true;
    userName = "Dov Alperin";
    userEmail = "git@dov.dev";
  };

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
    package = pkgs.go_1_18;
  };

  programs.jq = {
    enable = true;
  };
}
