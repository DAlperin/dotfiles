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
          (import ./overlays)
        ];
      };
      users = import ./users;
      mkComputer = configurationNix: userName: extraModules: extraHomeModules: extraArgs: inputs.nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit system inputs pkgs extraArgs; };
        modules = [
          configurationNix
          "./users/${userName}"

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users."${userName}" = {
              imports = [ ./home ./home/nixos ] ++ extraHomeModules;
            };
          }
        ] ++ extraModules;
      };
    in
    {
      nixosConfigurations = {
        nixosvm = mkComputer
          ./machines/nixosvm #machine specific configuration
          "dovalperin"
          [
            ./modules/gnome
            ./modules/1password
            ./modules/tailscale
            ./modules/ssh
          ]
          [
            ./modules/zsh
          ]
          {
            tskey = "tskey-knNVuH6CNTRL-JKERvdZq7G1bLjJw8rvTP";
          };
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


