{
  findutils,
  nix-grep-to-build,
  writeShellApplication,
}:
writeShellApplication {
  name = "nix-flake-check-changed";
  runtimeInputs = [
    findutils
    nix-grep-to-build
  ];
  text = builtins.readFile ./nix-flake-check-changed.sh;
}
