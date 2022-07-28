{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  llvmPackages_14,
  libxml2,
  zlib,
}:
stdenv.mkDerivation rec {
  pname = "zig";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "ziglang";
    repo = pname;
    rev = "c650ccfca719b695fe7752f9126e8dbcc2ab4d6d";
    hash = "sha256-/QjpF1F2N1JdhypXmXqSYilvCCJobf3e/uG2tUp/fwA=";
  };

  nativeBuildInputs = [
    cmake
    llvmPackages_14.llvm.dev
  ];

  buildInputs =
    [
      libxml2
      zlib
    ]
    ++ (with llvmPackages_14; [
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
    "-DZIG_STATIC_ZLIB=ON"
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
