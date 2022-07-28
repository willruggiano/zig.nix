{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    pre-commit.url = "github:cachix/pre-commit-hooks.nix";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
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
        nativeBuildInputs = with pkgs; [zig-latest];
        inherit (self.checks."${system}".pre-commit) shellHook;
      };

      packages.default = pkgs.zig-latest;
    })
    // {
      overlays.default = import ./packages;
    };
}
