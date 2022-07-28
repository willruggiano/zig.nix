final: prev: {
  zig-latest = final.zig-0-10-0;
  zig-0-10-0 = prev.callPackage ./zig-0-10-0.nix {};
}
