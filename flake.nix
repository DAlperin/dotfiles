{
  description = "Dovs nixos configs";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-21.11";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = github:NixOS/nixos-hardware/master;
    home-manager.url = "github:nix-community/home-manager/release-21.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    emacs-overlay.url = "github:nix-community/emacs-overlay/master";
    nix-matlab.url = "gitlab:doronbehar/nix-matlab";
    sops-nix.url = github:Mic92/sops-nix;
  };

  outputs = inputs@{ self, home-manager, nixpkgs, unstable, nixos-hardware, emacs-overlay, nix-matlab, sops-nix, ... }:
    let
      system = "x86_64-linux";
      pkgs =
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          overlays = [
            #We pass the 'unstable' input to overlays so it can add an 'unstable' overlay
            #to make unstable packages available everywhere in the configuration
            (import ./overlays { unstable = unstable; })
            emacs-overlay.overlay
            nix-matlab.overlay
          ];
        };
      defaultNixOptions = {
        nix.autoOptimiseStore = true;
      };
      mkComputer = configurationNix: userName: extraModules: extraHomeModules: inputs.nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit system inputs pkgs nixos-hardware; };
        modules = [
          #Secrets management
          sops-nix.nixosModules.sops
          #Machine config
          configurationNix
          defaultNixOptions
          #User config
          (./. + "/users/${userName}")
          #Home manager
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users."${userName}" = {
              imports = [ (./. + "/users/${userName}/home.nix") ] ++ extraHomeModules;
            };
          }
        ] ++ extraModules;
      };
    in
    {
      nixosConfigurations = {
        nixosvm = mkComputer
          ./machines/nixosvm #machine specific configuration
          "dovalperin" #default user
          [
            ./modules/gnome
            ./modules/1password
            ./modules/tailscale
            ./modules/ssh
          ] #modules to load
          [
            ./modules/zsh
          ]; #modules to be loaded by home-manager
        DovDev = mkComputer
          ./machines/DovDev #machine specific configuration
          "dovalperin" #default user
          [
            ./modules/xserver
            ./modules/gnome
            ./modules/tailscale
            ./modules/ssh
            ./modules/zoom
            ./modules/browsers
            ./modules/postgresql
            ./modules/redis
          ] #modules to load
          [
            ./modules/zsh
            ./modules/emacs
            ./modules/1password
          ]; #modules to be loaded by home-manager
      };

      #Nothing uses this anymore, should be deleted or turned into optional module
      homeConfigurations =
        let
          username = "dovalperin";
          stateVersion = "21.11";
          baseConfiguration = {
            programs.home-manager.enable = true;
            home.username = "dovalperin";
            home.homeDirectory = "/home/dovalperin";
          };
          mkHomeConfig = extraModules: home-manager.lib.homeManagerConfiguration {
            inherit username system stateVersion;
            homeDirectory = "/home/${username}";
            configuration = baseConfiguration // {
              imports = [ ./home ] ++ extraModules;
            };
          };
        in
        {
          "DovDev" = mkHomeConfig
            [
              ./modules/zsh
              ./machines/DovDevUbuntu
            ];
        };
    };
}


