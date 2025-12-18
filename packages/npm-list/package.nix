{
  gawk,
  gnused,
  jq,
  ripgrep,
  writeShellApplication,
}:

writeShellApplication {
  name = "npm-list";
  meta.description = "NPM list utils for a monorepo with many small NPM projects";
  runtimeInputs = [
    gawk
    gnused
    jq
    ripgrep
  ];
  text = builtins.readFile ./npm-list.sh;
}
