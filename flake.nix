{
  description = "Dovs nixos configs";
  inputs = {
    #Set to a specific 'unstable' commit. See https://status.nixos.org
    nixpkgs.url = "github:nixos/nixpkgs/931ab058daa7e4cd539533963f95e2bb0dbd41e6";
    nixos-hardware.url = github:NixOS/nixos-hardware/master;
    home-manager.url = "github:nix-community/home-manager/release-21.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, home-manager, nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [
          (import ./overlays.nix)
        ];
      };
      mkComputer = configurationNix: extraModules: inputs.nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit system inputs pkgs; };
        modules = [
          configurationNix

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.dovalperin = import ./home/nixos.nix;
          }
        ] ++ extraModules;
      };
    in
    {
      nixosConfigurations = {
        nixosvm = mkComputer
          ./machines/nixosvm.nix
          [
            ./modules/gnome.nix
          ];
      };
      homeConfigurations =
        let
          username = "dovalperin";
          stateVersion = "21.11";
          baseConfiguration = {
            programs.home-manager.enable = true;
            home.username = "dovalperin";
            home.homeDirectory = "/home/dovalperin";
          };
          mkHomeConfig = cfg: home-manager.lib.homeManagerConfiguration {
            inherit username system stateVersion;
            homeDirectory = "/home/${username}";
            configuration = baseConfiguration // cfg;
          };
        in
        {
          "DovDev" = mkHomeConfig {
            imports = [
              ./home/home.nix
              ./machines/DovDevUbuntu.nix
            ];
          };
        };
    };
}


