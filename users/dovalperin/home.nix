{ pkgs, config, ... }: {
  #Home manager configuration
  home.username = "dovalperin";
  home.homeDirectory = "/home/dovalperin";
  home.stateVersion = "21.11";
  imports = [ ./../../home ./../../home/nixos ];

  home.packages = with pkgs; [
    loc
    discord
    yarn
    bat
    eza
    lsof
    dig
    nerdfonts
    (hiPrio bintools)
    xclip
    tree-sitter
    mercurial
    age
    sops
    steam-run
    pscale
    gcc
    fira-code
    libreoffice
    asciinema
    jetbrains.idea-ultimate
    jetbrains.clion
    postman
    insomnia
    docker-compose
    glib
    slack
    pandoc
    peek
    rustup
    neofetch
    htop
    _1password
    gh
    vlc
    signal-desktop
    unstable.zellij
  ];

  dov = {
    zsh.enable = true;
    emacs.enable = true;
  };

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

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
    package = pkgs.unstable.go_1_23;
  };

  programs.jq = {
    enable = true;
  };

  dconf.settings = {
    "org/gnome/mutter" = {
      experimental-features = [ "x11-randr-fractional-scaling" ];
    };
  };
}
