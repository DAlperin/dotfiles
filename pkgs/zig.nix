{ lib
, fetchFromGitHub
, cmake
, llvmPackages_13
, libxml2
, zlib
}:

let
  inherit (llvmPackages_13) stdenv;
in
stdenv.mkDerivation rec {
  pname = "zig";
  version = "master";

  src = fetchFromGitHub {
    owner = "ziglang";
    repo = pname;
    rev = version;
    hash = "sha256-MPOusl24ET5WT/VHPJBJZmKchSurvvWfpB+XLwxW4Vo=";
  };

  nativeBuildInputs = [
    cmake
    llvmPackages_13.llvm.dev
  ];

  buildInputs = [
    libxml2
    zlib
  ] ++ (with llvmPackages_13; [
    libclang
    lld
    llvm
  ]);

  preBuild = ''
    export HOME=$TMPDIR;
  '';

  doCheck = true;
  checkPhase = ''
    runHook preCheck
    ./zig test --cache-dir "$TMPDIR" -I $src/test $src/test/behavior.zig
    runHook postCheck
  '';

  meta = with lib; {
    homepage = "https://ziglang.org/";
    description =
      "General-purpose programming language and toolchain for maintaining robust, optimal, and reusable software";
    license = licenses.mit;
    maintainers = with maintainers; [ andrewrk AndersonTorres ];
    platforms = platforms.unix;
    broken = stdenv.isDarwin; # See https://github.com/NixOS/nixpkgs/issues/86299
  };
}
