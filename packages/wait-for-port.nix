{ writeShellApplication, netcat }:
writeShellApplication {
  name = "wait-for-port";
  # beware: the first result on nixos search, netcat-gnu, is outdated and
  # broken.
  runtimeInputs = [ netcat ];
  text = ''
    if [[ $# -eq 0 ]] ; then
        nc
        exit 1
    fi
    until nc -z localhost "$@"; do sleep 1; done
  '';
}
