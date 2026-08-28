{ writeShellApplication, netcat }:
writeShellApplication {
  name = "wait-for-port";
  # beware: the first result on nixos search, netcat-gnu, is outdated and
  # broken.
  runtimeInputs = [ netcat ];
  text = builtins.readFile ./wait-for-port.sh;
}
