self: super: {
  gnomeExtensions = super.gnomeExtensions // {
    adwaita-theme-switcher = super.callPackage ./pkgs/adwaita-theme-switcher.nix { };
  };
}