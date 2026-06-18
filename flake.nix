{
  inputs = {
    # keep-sorted start block=true
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    package-lock2nix = {
      url = "github:anteriorcore/package-lock2nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
      inputs.treefmt-nix.follows = "treefmt-nix";
    };
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
                package-lock2nix = pkgs.callPackage inputs.package-lock2nix.lib.package-lock2nix {
                  inherit (pkgs) nodejs;
                };
                all = lib.packagesFromDirectoryRecursive {
                  newScope = self: pkgs.newScope (self // { inherit package-lock2nix; });
                  inherit (pkgs) callPackage;
                  directory = ./packages;
                };
              in
              {
                inherit (all)
                  # keep-sorted start
                  conventional-commit
                  docsync
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
