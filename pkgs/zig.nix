{ lib
, fetchFromGitHub
, cmake
, llvmPackages_14
, libxml2
, zlib
}:

let
  inherit (llvmPackages_14) stdenv;
in
stdenv.mkDerivation rec {
  pname = "zig";
  version = "master";

  src = fetchFromGitHub {
    owner = "ziglang";
    repo = pname;
    rev = version;
    hash = "sha256-WILRh/RmT8u8JZ7szDVnYg8A6aT2jN/R+GNZs+lJO+c=";
  };

  nativeBuildInputs = [
    cmake
    llvmPackages_14.llvm.dev
    llvmPackages_14.clang
    llvmPackages_14.clang-unwrapped
  ];

  buildInputs = [
    libxml2
    zlib
  ] ++ (with llvmPackages_14; [
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

  cmakeFlags = [
    # https://github.com/ziglang/zig/issues/12069
    "-DZIG_STATIC_ZLIB=on"
  ];

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
