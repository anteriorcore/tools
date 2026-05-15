{ ... }:
{
  projectRootFile = "flake.nix";
  programs = {
    # keep-sorted start block=true
    keep-sorted.enable = true;
    nixfmt = {
      enable = true;
      strict = true;
    };
    yamlfmt.enable = true;
    # keep-sorted end
  };
}
