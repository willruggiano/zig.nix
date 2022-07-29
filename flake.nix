{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    pre-commit.url = "github:cachix/pre-commit-hooks.nix";
    utils.url = "github:gytis-ivaskevicius/flake-utils-plus";
    zig.url = "github:willruggiano/zig/feat/nix-flake?dir=contrib";
    zig.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    zig,
    utils,
    ...
  } @ inputs:
    utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          self.overlays.default
          self.overlays.release
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

      packages = utils.lib.exportPackages self.overlays {inherit pkgs zig;} // {default = pkgs.zig-master;};
    })
    // {
      overlays = {
        inherit (zig.overlays) default;
        release = import ./packages/releases.nix;
      };
    };
}
