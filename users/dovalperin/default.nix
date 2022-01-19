{ pkgs, config, ... }:
{
  home-manager.users.dovalperin = {
    home.username = "dovalperin";
    home.homeDirectory = "/home/dovalperin";
    imports = [ ./../../home ./../../home/nixos ];

  home.packages = with pkgs; [
    yarn
    bat
    exa
    rustup
    nodejs-16_x
    lsof
    spotify
    thunderbird
    ghidra-bin
    signal-desktop
    unstable.jetbrains.idea-ultimate
    unstable.jetbrains.clion
    pencil
    niv
    dig
    usbutils
    evolution
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
  ];
    # These are loaded by home-manager. Not the system
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
  };

  users.users.dovalperin = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = config.dov.ssh.authorizedKeys;
  };

  dov = {
    postgres.enable = true;
    redis.enable = true;
    browsers.brave.enable = true;
    "1password".enable = true;
    ssh.enable = true;
    zoom.enable = true;
  };

  virtualisation.docker.enable = true;

  programs.zsh.enable = true;
}
