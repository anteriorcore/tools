{ writeShellApplication, netcat }:
writeShellApplication {
  name = "wait-for-port";
  # beware: the first result on nixos search, netcat-gnu, is outdated and
  # broken.
  runtimeInputs = [ netcat ];
  text = ''
    until nc -z localhost "$1"; do sleep 1; done
  '';
}
