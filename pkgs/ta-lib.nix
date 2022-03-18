{ stdenv, fetchurl, gettext, attr }:
stdenv.mkDerivation rec {
  version = "0.4.0";
  name = "ta-lib-${version}";
  src = fetchurl {
    url = "http://prdownloads.sourceforge.net/ta-lib/${name}-src.tar.gz";
    sha256 = "0lf69nna0aahwpgd9m9yjzbv2fbfn081djfznssa84f0n7y1xx4z";
  };
  nativeBuildInputs = [ gettext ];
  buildInputs = [ attr ];
  meta = {
    homepage = http://ta-lib.org/index.html;
    description = "Multi-Platform Tools for Stock Market Analysis";
  };
}
