{ lib, stdenv, glib, pkgs, ... }:

stdenv.mkDerivation rec {
  pname = "advanced-alttab-window-switcher";
  version = "5";

  src = pkgs.fetchFromGitHub {
    owner = "G-dH";
    repo = "advanced-alttab-window-switcher";
    rev = "6a43e56a5310bdd1a770a845b7f358b745605ab0";
    sha256 = "1rvrih9yfxdy1vagx54p0dmakl88fds3fgjgfpdb1by2bwl2wm1y";
  };

  passthru = {
    extensionPortalSlug = "advanced-alttab-window-switcher";
    extensionUuid = "advanced-alt-tab@G-dH.github.com";
  };

  nativeBuildInputs = [
    glib 
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/gnome-shell/extensions/
    cp -r . $out/share/gnome-shell/extensions/advanced-alt-tab@G-dH.github.com
    runHook postInstall
  '';

  meta = with lib; {
    description = "Temp self packaged extension until nixpkgs catches up";
  };
}