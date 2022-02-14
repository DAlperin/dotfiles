{ lib, config, pkgs, ... }:

with lib;

let
  cfg = config.dov.zsh;
in
{
  options.dov.zsh.enable = mkEnableOption "zsh config";

  config = mkIf cfg.enable
    {
      programs.zsh = {
        enable = true;
        enableCompletion = false;
        oh-my-zsh = {
          enable = true;
        };
        shellAliases = {
          ls = "exa -GFh";
          cls = "clear";
          cat = "bat --paging=never";
          catl = "bat";
          catp = "bat --plain";
          reload = "source ~/.zshrc";
          open-profile = "nvim ~/.zshrc";
          nd = "nix develop --command zsh";
        };
        sessionVariables = {
          SPACESHIP_PROMPT_ADD_NEWLINE = "false";
          SPACESHIP_PROMPT_SEPARATE_LINE = "false";
          SPACESHIP_USER_SHOW = "always";
          SPACESHIP_HOST_SHOW = "always";
          SPACESHIP_BATTERY_SHOW = " always";
          SPACESHIP_BATTERY_PREFIX = "🔋";
          ZSH_AUTOSUGGEST_STRATEGY = [ "history" ];
          GPG_TTY = "$(tty)";
          EDITOR = "nvim";
          SPACESHIP_NIXSHELL_SHOW = "\${SPACESHIP_NIXSHELL_SHOW=true}";
          SPACESHIP_NIXSHELL_PREFIX = "\${SPACESHIP_NIXSHELL_PREFIX=\"nix-shell \"}";
          SPACESHIP_NIXSHELL_SUFFIX = "\${SPACESHIP_NIXSHELL_SUFFIX=\"$SPACESHIP_PROMPT_DEFAULT_SUFFIX\"}";
          SPACESHIP_NIXSHELL_SYMBOL = "\${SPACESHIP_NIXSHELL_SYMBOL=\"❄️\"}";
          KUBECONFIG = "$HOME/.kube/config:$HOME/.kube/test-cluster-kubeconfig.yaml";
          GHPACKAGESTOKEN = "$(cat /run/secrets/gh_packages_key)";
        };
        initExtra = ''
          bindkey '^ ' autosuggest-accept

          spaceship_nixshell() {
            [[ $SPACESHIP_NIXSHELL_SHOW == false ]] && return
            [[ -z $IN_NIX_SHELL ]] && return
            spaceship::section \
              "yellow" \
              "$SPACESHIP_NIXSHELL_PREFIX" \
              "$SPACESHIP_NIXSHELL_SYMBOL $IN_NIX_SHELL" \
              "$SPACESHIP_NIXSHELL_SUFFIX"
          }

          # This is a hack and assumes that nixshell will always be first if it is present at all
          if [ $SPACESHIP_PROMPT_ORDER[1] != nixshell ]; then
            SPACESHIP_PROMPT_ORDER=(nixshell $SPACESHIP_PROMPT_ORDER)
          fi

          function move {
            if [ ! -n "$1" ]; then
              echo "Enter a directory name"
            elif [ -d $1 ]; then
              echo "\`$1' already exists"
            else
              mkdir $1 && cd $1
            fi
          }

          function zsh_history_fix {
            mv ~/.zsh_history ~/.zsh_history_bad
            strings ~/.zsh_history_bad > ~/.zsh_history
            fc -R ~/.zsh_history
            rm ~/.zsh_history_bad
          }
          function copy {
            if [ ! -n "$1" ]; then
              echo "Enter a filename"
            else
              xclip $1 -selection clipboard
            fi
          }
          PATH=/home/dovalperin/.yarn/bin:$PATH
          PATH=/home/dovalperin/.cargo/bin:$PATH
          PATH=/home/dovalperin/.local/bin:$PATH
          PATH="/home/dovalperin/.krew/bin:$PATH"
        '';
        plugins = [
          {
            name = "spaceship-prompt";
            file = "spaceship.zsh-theme";
            src = pkgs.fetchFromGitHub {
              owner = "spaceship-prompt";
              repo = "spaceship-prompt";
              rev = "v3.16.1";
              sha256 = "sXnL57g5e7KboLXHzXxSD0+8aKPNnTX6Q2yVft+Pr7w=";
            };
          }
          {
            name = "zsh-autosuggestions";
            file = "zsh-autosuggestions.plugin.zsh";
            src = pkgs.fetchFromGitHub {
              owner = "zsh-users";
              repo = "zsh-autosuggestions";
              rev = "a411ef3e0992d4839f0732ebeb9823024afaaaa8";
              sha256 = "1g3pij5qn2j7v7jjac2a63lxd97mcsgw6xq6k5p7835q9fjiid98";
            };
          }
          {
            name = "nix-zsh-completions";
            file = "nix-zsh-completions.plugin.zsh";
            src = pkgs.fetchFromGitHub {
              owner = "spwhitt";
              repo = "nix-zsh-completions";
              rev = "468d8cf752a62b877eba1a196fbbebb4ce4ebb6f";
              sha256 = "16r0l7c1jp492977p8k6fcw2jgp6r43r85p6n3n1a53ym7kjhs2d";
            };
          }
          {
            name = "fzf-tab";
            file = "fzf-tab.plugin.zsh";
            src = pkgs.fetchFromGitHub {
              owner = "Aloxaf";
              repo = "fzf-tab";
              rev = "190500bf1de6a89416e2a74470d3b5cceab102ba";
              sha256 = "1dipsy0s67fr47ig5559bcp1h5yn8rdjshhs8zsq7j8plvvh99qb";
            };
          }
          {
            name = "nix-shell";
            file = "nix-shell.plugin.zsh";
            src = pkgs.fetchFromGitHub {
              owner = "chisui";
              repo = "zsh-nix-shell";
              rev = "v0.4.0";
              sha256 = "037wz9fqmx0ngcwl9az55fgkipb745rymznxnssr3rx9irb6apzg";
            };
          }
          {
            name = "zsh-syntax-highlighting";
            file = "zsh-syntax-highlighting.plugin.zsh";
            src = pkgs.fetchFromGitHub {
              owner = "zsh-users";
              repo = "zsh-syntax-highlighting";
              rev = "c7caf57ca805abd54f11f756fda6395dd4187f8a";
              sha256 = "0cvz071fz67wf8kjavizyq6adm206945byqlv9ib59c96yl8zsri";
            };
          }
        ];
      };
    };
}
