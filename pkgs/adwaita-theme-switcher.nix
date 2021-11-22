{ lib, stdenv, glib, pkgs, ... }:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-adwaita-theme-switcher";
  version = "2";

  src = pkgs.fetchFromGitHub {
    owner = "fthx";
    repo = "adwaita-theme-switcher";
    rev = "b267dc8dbbfaba7e1e3018dde63ca32a06f4fec8";
    sha256 = "08dzr7k4877j7w3qys937yhar5anlykikb1ndnxmi2861nh04483";
  };

  passthru = {
    extensionPortalSlug = "adwaita-theme-switcher";
    extensionUuid = "adwaita-theme-switcher@fthx";
  };

  nativeBuildInputs = [
    glib
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/gnome-shell/extensions/
    cp -r . $out/share/gnome-shell/extensions/adwaita-theme-switcher@fthx
    runHook postInstall
  '';

  meta = with lib; {
    description = "Temp self packaged extension until nixpkgs catches up";
  };
}
