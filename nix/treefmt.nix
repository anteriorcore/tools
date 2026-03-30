{ ... }:
{
  projectRootFile = "flake.nix";
  programs.nixfmt = {
    enable = true;
    strict = true;
  };
  programs.keep-sorted.enable = true;

}
