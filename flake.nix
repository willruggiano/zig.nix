{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    pre-commit.url = "github:cachix/pre-commit-hooks.nix";
    utils.url = "github:numtide/flake-utils";
    zig-flake.url = "github:willruggiano/zig/feat/nix-flake?dir=contrib";
    zig-flake.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    zig-flake,
    ...
  } @ inputs:
    inputs.utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          self.overlays.default
        ];
      };
    in {
      checks = {
        pre-commit = inputs.pre-commit.lib."${system}".run {
          src = ./.;
          hooks = {
            alejandra.enable = true;
          };
        };
      };

      devShells.default = pkgs.mkShell {
        name = "zig";
        nativeBuildInputs = with pkgs; [zig-master];
        inherit (self.checks."${system}".pre-commit) shellHook;
      };
    })
    // {
      overlays = {
        inherit (zig-flake.overlays) default;
        release = import ./packages;
      };
    };
}
