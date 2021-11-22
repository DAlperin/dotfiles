self: super: {
  gnomeExtensions = super.gnomeExtensions // {
    adwaita-theme-switcher = super.callPackage ./pkgs/adwaita-theme-switcher.nix { };
  };
  _1password-gui = super._1password-gui.overrideAttrs (old: {
    version = "8.3.0";
  });
}
