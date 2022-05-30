{ unstable }:
self: super: {
  gnomeExtensions = super.gnomeExtensions // {
    adwaita-theme-switcher = super.callPackage ../pkgs/adwaita-theme-switcher.nix { };
    advanced-alttab-window-switcher = super.callPackage ../pkgs/advanced-alt-tab.nix { };
  };
  #_1password-gui = super.callPackage ../pkgs/1password-gui.nix { };
  #_1password = super.callPackage ../pkgs/1password.nix { };
  kubeseal = super.callPackage ../pkgs/kubeseal.nix { };
  unstable = import unstable {
    system = "${super.system}";
    config.allowUnfree = true;
  };
  plasma-desktop = unstable.plasma-desktop;
  ta-lib = super.callPackage ../pkgs/ta-lib.nix { };
  # I should probably just upstream this, this is basically just re-writing an entire package at this point
  betaflight-configurator = super.betaflight-configurator.overrideAttrs (old: rec {
    pname = "betaflight-configurator";
    src = super.fetchurl {
      url = "https://github.com/betaflight/betaflight-configurator/releases/download/10.8.0-RC3/betaflight-configurator_10.8.0_linux64-portable.zip";
      sha256 = "sha256-iOfwS0xD87fcepKG7TW9Crrk2JkZWUnIBY/jgh9m4so=";
    };
    desktopItem = super.makeDesktopItem {
      name = pname;
      exec = pname;
      icon = pname;
      comment = "Betaflight configuration tool";
      desktopName = "Betaflight Configurator";
      genericName = "Flight controller configuration tool";
    };
    installPhase = ''
      mkdir -p $out/bin \
              $out/opt/${pname}
      cp -r . $out/opt/${pname}/
      install -m 444 -D icon/bf_icon_128.png $out/share/icons/hicolor/128x128/apps/${pname}.png
      cp -r ${desktopItem}/share/applications $out/share/
      makeWrapper ${super.pkgs.unstable.nwjs}/bin/nw $out/bin/${pname} --add-flags $out/opt/${pname}
    '';
  });
  zig = super.callPackage ../pkgs/zig.nix { };
  bun = super.callPackage ../pkgs/bun.nix { };
}
