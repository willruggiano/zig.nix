{
  zig,
  fetchFromGitHub,
}:
zig.overrideAttrs (_: rec {
  version = "0.9.0";
  src = fetchFromGitHub {
    owner = "ziglang";
    repo = "zig";
    rev = version;
    hash = "sha256-Hfl1KKtGcopMrn+U9r0/qr/wReWJIgb8+IgwMoguv/0=";
  };
})
