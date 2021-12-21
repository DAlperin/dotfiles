self: super: {
  gnomeExtensions = super.gnomeExtensions // {
    adwaita-theme-switcher = super.callPackage ../pkgs/adwaita-theme-switcher.nix { };
    advanced-alttab-window-switcher = super.callPackage ../pkgs/advanced-alt-tab.nix { };
  };
  _1password-gui = super._1password-gui.overrideAttrs (old: {
    version = "8.4.1";
    src = super.fetchurl {
      url = "https://downloads.1password.com/linux/tar/stable/x86_64/1password-8.4.1.x64.tar.gz";
      sha256 = "sha256-9cJGgSfDY7Oj0vpYV7b/CXnurxSFwa+xFLOSnB/Ep98=";
    };
  });
  tailscale = super.callPackage ../pkgs/tailscale.nix { };
}
