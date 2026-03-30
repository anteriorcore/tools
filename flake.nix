{
  inputs = {
    # keep-sorted start block=true
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    systems.url = "systems";
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # keep-sorted end
  };

  outputs =
    { self, flake-parts, ... }@inputs:
    let
      checkBuildAll = import ./nix/check-build-all.nix;
      dynamodb = import ./nix/dynamodb.module.nix;
      elasticmq = import ./nix/elasticmq.module.nix;
      allSystems = {
        flake.flakeModules = { inherit checkBuildAll; };
        flake.nixosModules = { inherit dynamodb elasticmq; };
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
                inherit (all)
                  # keep-sorted start
                  nix-flake-check-changed
                  nix-grep-to-build
                  npm-list
                  wait-for-port
                  # keep-sorted end
                  ;
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
