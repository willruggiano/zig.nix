{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  llvmPackages_13,
  libxml2,
  zlib,
}:
llvmPackages_13.stdenv.mkDerivation rec {
  pname = "zig";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "ziglang";
    repo = pname;
    rev = version;
    hash = "sha256-x2c4c9RSrNWGqEngio4ArW7dJjW0gg+8nqBwPcR721k=";
  };

  nativeBuildInputs = [
    cmake
    llvmPackages_13.llvm.dev
  ];

  buildInputs =
    [
      libxml2
      zlib
    ]
    ++ (with llvmPackages_13; [
      libclang
      lld
      llvm
    ]);

  preBuild = ''
    export HOME=$TMPDIR;
  '';

  cmakeFlags = [
    # file RPATH_CHANGE could not write new RPATH
    "-DCMAKE_SKIP_BUILD_RPATH=ON"
  ];

  doCheck = true;
  checkPhase = ''
    runHook preCheck
    ./zig test --cache-dir "$TMPDIR" -I $src/test $src/test/behavior.zig
    runHook postCheck
  '';

  meta = with lib; {
    homepage = "https://ziglang.org/";
    description = "General-purpose programming language and toolchain for maintaining robust, optimal, and reusable software";
    license = licenses.mit;
    maintainers = with maintainers; [aiotter andrewrk AndersonTorres];
    platforms = platforms.unix;
  };
}
