# My Nix/NixOS configs

I don't recommend using these without some serious customization unless you are me. A lot of stuff has a bunch of assumptions/opinions that are nonstandard. That said feel free to use any of this repo as example code or as a template. I am extremely grateful for those who put their configs up before me, they are an awesome learning resource.

## Disclaimer
I am not *good* at Nix/NixOS. Don't take any of the following notes (or code from this repo) to indicate something being the correct way. 

## A breakdown

### **flake.nix**
The majority of work in building Nixos systems happens in the `mkComputer` function inside flake.nix:
```nix
mkComputer = configurationNix: userName: extraModules: extraHomeModules: extraArgs: inputs.nixpkgs.lib.nixosSystem {
  inherit system;
  specialArgs = { inherit system inputs pkgs extraArgs; };
  modules = [
    configurationNix
    (./. + "/users/${userName}")

    home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users."${userName}" = {
          imports = extraHomeModules;
      };
    }
  ] ++ extraModules;
};
```
The function takes 5 parameters:
1. `configurationNix`
   - machine specific configuration, most likely something from ./machines
2. `userName`
   - "primary" user
3. `extraModules`
   - modules to load globally
4. `extraHomeModules`
   - modules to load in `userName`s home-manager context
5. `extraArgs`
   - arguments passed to all global modules

The following (non flake) top level variables are defined in flake.nix
```nix
system = "x86_64-linux";
pkgs = import nixpkgs {
  inherit system;
  config.allowUnfree = true;
  overlays = [
    (import ./overlays)
  ];
};
```
1. `system`
2. `pkgs`
   - the nixpkgs config that everything uses
   - loads overlays

### **./overlays**
The overlays module provides these packages:
```nix
gnomeExtensions = super.gnomeExtensions // {
  adwaita-theme-switcher = super.callPackage ../pkgs/adwaita-theme-switcher.nix { };
  advanced-alttab-window-switcher = super.callPackage ../pkgs/advanced-alt-tab.nix { };
};
_1password-gui = super._1password-gui.overrideAttrs (old: {
  version = "8.3.0";
});
tailscale = super.callPackage ../pkgs/tailscale.nix { };
```
1. `gnomeExtensions`
   - nixpkgs does not have up to date versions of many gnome extensions rendering them unusable on gnome 40/41
2. `_1password-gui`
   - update to latest version
3. `tailscale`
   - use our own tailscale package to build newer versions of tailscale which require go 17

### **./pkgs**
1. `advanced-alt-tab.nix`
   - advanced-alttab-window-switcher
2. `adwaita-theme-switcher.nix`
   - gnome-shell-extension-adwaita-theme-switcher
3. `tailscale.nix`
   - tailscale

### **./modules**
1. `1password`
   - enable 1password globally
2. `gnome`
   - enable gnome/gdm with all of my plugins
3. `ssh`
   - enable sshd and provide my authorized keys
4. `tailscale`
   - enable tailscaled and attempt to authenticate using the tsKey specified in the mkComputer call if tailscale is not already logged in
5. `zsh`
   - zsh configs, ohMyZsh + plugins + aliases + some zsh code to be sourced

### **./home**
1. `default.nix`
   - home manager config - installs all packages and configures programs that get installed everywhere (including ubuntu)
2. `nixos`
   - nixos specific home-manager configs