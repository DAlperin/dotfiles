# My Nix/NixOS configs

I don't recommend using these without some serious customization unless you are me. A lot of stuff has a bunch of assumptions/opinions that are nonstandard. That said feel free to use any of this repo as example code or as a template. I am extremely grateful for those who put their configs up before me, they are an awesome learning resource.

## Disclaimer
I am not *good* at Nix/NixOS. Don't take any of the following notes (or code from this repo) to indicate something being the correct way. 

## Structure 
```
project
│   README.md
│   flake.nix (entry to configuration)
│   .sops.yaml (config for sops storage encryption)
│   ...
│
└───emacs (doom emacs config)
│   │   install (install script that symlinks emacs config into place)
│   │   file012.txt
│   │   ...
│
└───home (default home-manager configs)
│   │   ...
│
└───machines (hardware configuration for all machines this config runs on)
│   └───ascent (ephemeral matrix host)
│   │   ...
│   └───DovDev (daily driver laptop)
│   │   ...
│   └───DovDevUbuntu (nix on ubuntu)
│   │   ...
│   └───nixosvm (base config for running nixos on a virtualbox vm)
│   │   ...
│
└───modules (custom nixos modules)
│   │   ...
│
└───overlays
│   │   default.nix (default package overides)
│
└───pkgs (custom packages)
│   │   ...
│
└───users
│   └───$user
│   │   default.nix (called in the system context)
│   │   home.nix (called in the home-manager context)
```
