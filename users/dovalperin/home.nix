{ pkgs, config, ... }: {
  #Home manager configuration
  home.username = "dovalperin";
  home.homeDirectory = "/home/dovalperin";
  imports = [ ./../../home ./../../home/nixos ];

  home.packages = with pkgs; [
    #pinentry
    element-desktop
    discord
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
    direnv
    matlab
    matlab-shell
    matlab-mlint
    matlab-mex
    git-privacy
    lens
    minikube
    kubectl
    unstable.fluxcd
    kubeseal
    linode-cli
    telnet
    mercurial
    krew
    wireshark
    #gnupg
    age
    sops
    minecraft
  ];

  dov = {
    zsh.enable = true;
    emacs.enable = true;
    "1password".enable = true;
  };

  programs.home-manager.enable = true;

  programs.vscode.enable = true;

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
