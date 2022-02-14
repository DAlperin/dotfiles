{ unstable }:
self: super: {
  gnomeExtensions = super.gnomeExtensions // {
    adwaita-theme-switcher = super.callPackage ../pkgs/adwaita-theme-switcher.nix { };
    advanced-alttab-window-switcher = super.callPackage ../pkgs/advanced-alt-tab.nix { };
  };
  _1password-gui = super._1password-gui.overrideAttrs (old: {
    version = "8.5.0";
    src = super.fetchurl {
      url = "https://downloads.1password.com/linux/tar/stable/x86_64/1password-8.5.0.x64.tar.gz";
      sha256 = "tnZr+qjUcJ9Fhk6RP8iwu+/JsvYSE03NHhBfhedyCTQ=";
    };
  });
  tailscale = super.callPackage ../pkgs/tailscale.nix { };
  kubeseal = super.callPackage ../pkgs/kubeseal.nix { };
  unstable = import unstable {
    system = "${super.system}";
    config.allowUnfree = true;
  };
  plasma-desktop = unstable.plasma-desktop;
}
