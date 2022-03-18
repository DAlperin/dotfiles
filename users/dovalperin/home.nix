{ pkgs, config, ... }: {
  #Home manager configuration
  home.username = "dovalperin";
  home.homeDirectory = "/home/dovalperin";
  imports = [ ./../../home ./../../home/nixos ];

  home.packages = with pkgs; [
    gitoxide
    loc
    appimage-run
    mcrcon
    betaflight-configurator
    element-desktop
    unstable.discord
    yarn
    bat
    exa
    rustup
    nodejs-16_x
    lsof
    spotify
    thunderbird
    signal-desktop
    unstable.jetbrains.idea-ultimate
    unstable.jetbrains.clion
    dig
    nerdfonts
    (hiPrio bintools)
    xclip
    tree-sitter
    exercism
    matlab
    matlab-shell
    matlab-mlint
    matlab-mex
    git-privacy
    kubectl
    unstable.fluxcd
    kubeseal
    mercurial
    wireshark
    age
    sops
    minecraft
    steam-run
  ];

  dov = {
    zsh.enable = true;
    emacs.enable = true;
    #    "1password".enable = true;
  };

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
  programs.direnv.nix-direnv.enableFlakes = true;

  programs.home-manager.enable = true;

  programs.vscode = {
    enable = true;
    package = pkgs.unstable.vscode;
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
  };

  programs.jq = {
    enable = true;
  };
}
