{ lib
, stdenv
, autoPatchelfHook
, makeWrapper
, jetbrains
, zlib
, glib
, libX11
, libXi
, libXrender
, freetype
, alsa-lib
, libXtst
, jdk
}:

stdenv.mkDerivation rec {
  pname = "jetbrains-gateway";
  version = "222.2270.16";

  src = builtins.fetchurl {
    url = "https://download.jetbrains.com/idea/gateway/JetBrainsGateway-222.2270.16.tar.gz";
    sha256 = "sha256:03frqm0km0wpcmnd917z8icqjb2ng2s86vhzmw71aw9g77sk8wnd";
  };

  nativeBuildInputs = [ autoPatchelfHook makeWrapper ];
  buildInputs = [
    jetbrains.jdk
    zlib
    glib
    libX11
    libXi
    libXrender
    freetype
    alsa-lib
    libXtst
  ];

  installPhase = ''
    mkdir -p $out/share
    cp -r . $out/share
    rm -r $out/share/jbr

    makeWrapper \
      $out/share/bin/gateway.sh \
      $out/bin/jetbrains-gateway \
      --prefix LD_LIBRARY_PATH : $out/lib \
      --set GATEWAY_JDK "${jdk}" \
      --set JETBRAINSCLIENT_JDK "${jetbrains.jdk.home}"
  '';
}
