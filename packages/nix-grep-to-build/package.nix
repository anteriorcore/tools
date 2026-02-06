{ writeShellApplication, gnused }:
writeShellApplication {
  name = "nix-grep-to-build";
  runtimeInputs = [ gnused ];
  text = builtins.readFile ./nix-grep-to-build.sh;
}
