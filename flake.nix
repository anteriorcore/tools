{
  inputs = {
    # keep-sorted start block=true
    blockinfile = {
      url = "github:dustinsand/blockinfile/v0.1.11";
      flake = false;
    };
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
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
        perSystem = { pkgs, lib, ... }: {
          packages =
            let
              scope = lib.makeScope pkgs.newScope (self: {
                inherit inputs;
              });
              allPackages = lib.packagesFromDirectoryRecursive {
                inherit (scope) callPackage newScope;
                directory = ./packages;
              };
            in
            {
              inherit (allPackages)
                # keep-sorted start
                blockinfile
                conventional-commit
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
