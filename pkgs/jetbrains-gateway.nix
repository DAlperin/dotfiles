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
  version = "223.4884.79";

  src = builtins.fetchurl {
    url = "https://download.jetbrains.com/idea/gateway/JetBrainsGateway-${version}.tar.gz";
    sha256 = "sha256:1kvyxcz2fvqa4q2w7jvkgk7rqg7zfj489rrc3nfdwqsdkfw54wrp";
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
