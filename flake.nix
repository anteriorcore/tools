{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    systems.url = "systems";
    flake-parts.url = "github:hercules-ci/flake-parts";
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self, flake-parts, ... }@inputs:
    let
      checkBuildAll = import ./nix/check-build-all.nix;
      allSystems = {
        flake.flakeModules = { inherit checkBuildAll; };
        perSystem =
          { pkgs, lib, ... }:
          {
            packages =
              let
                all = lib.packagesFromDirectoryRecursive {
                  inherit (pkgs) callPackage newScope;
                  directory = ./packages;
                };
              in
              {
                inherit (all) nix-flake-check-changed nix-grep-to-build npm-list;
              };
            treefmt = import ./nix/treefmt.nix;
          };
      };
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import inputs.systems;
      imports = [
        inputs.treefmt-nix.flakeModule
        allSystems
        checkBuildAll
      ];
    };
}
