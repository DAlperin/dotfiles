{ pkgs, ... }:
let
  version = "0.0.81";
in pkgs.stdenv.mkDerivation {
    pname = "bun";
    version = version;
    src =  pkgs.fetchurl {
      url = "https://github.com/Jarred-Sumner/bun-releases-for-updater/releases/download/bun-v${version}/bun-linux-x64.zip";
      sha256 = "sha256-EPHhq4VoDg+k6j1UtR2TrapCkoL9d1Z7c6eCwzuGMe4=";
    };
    sourceRoot = ".";
    unpackCmd = "unzip bun-linux-x64.zip";
    dontConfigure = true;
    dontBuild = true;
    nativeBuildInputs = [ pkgs.autoPatchelfHook ];
    buildInputs = [ pkgs.unzip pkgs.openssl pkgs.stdenv.cc.cc.lib ];

    installPhase = "install -D ./bun-linux-x64/bun $out/bin/bun";
}
