{ pkgs, config, ... }: {
  #Home manager configuration
  home.username = "dovalperin";
  home.homeDirectory = "/home/dovalperin";
  imports = [ ./../../home ./../../home/nixos ];

  home.packages = with pkgs; [
    loc
    element-desktop
    discord
    yarn
    bat
    exa
    nodejs-16_x
    lsof
    spotify
    thunderbird
    dig
    nerdfonts
    (hiPrio bintools)
    xclip
    tree-sitter
    exercism
    mercurial
    age
    sops
    steam-run
    pscale
    gcc
    #flyctl
    fira-code
    libreoffice
    asciinema
    jetbrains.idea-ultimate
    jetbrains.clion
    postman
    insomnia
    docker-compose
    terraform
    glib
    slack
    gimp
    ghidra
    pandoc
    peek
    rustup
    neofetch
    htop
    _1password
    jetbrains-gateway
    gh
    vlc
    solaar
    piper
    polymc
    remmina
    signal-desktop
    zig
    nheko
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
    package = pkgs.unstable.go_1_19;
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
