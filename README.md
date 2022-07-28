# zig.nix

A collection of Nix utilities for working with Zig in Nix/NixOS.

## Contents

- A Nix overlay; provides additional Zig versions not currently in nixpkgs

## Cachix

As part of a NixOS configuration;

```nix
config.nix.settings = {
  substituters = [
    "https://willruggiano.cachix.org"
  ];
  trusted-public-keys = [
    "willruggiano.cachix.org-1:rz00ME8/uQfWe+tN3njwK5vc7P8GLWu9qbAjjJbLoSw="
  ];
};
```

Using plain old cachix;

```sh
$ cachix use willruggiano
```

## TODO

- [ ] `zigStdenv`; a `stdenv` but for Zig
- [ ] Generate all possible versions based on [zig data][zig-index]

[zig-index]: https://ziglang.org/download/index.json
