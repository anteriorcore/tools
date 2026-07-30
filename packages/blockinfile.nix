{ inputs, buildGoModule }:
buildGoModule {
  pname = "blockinfile";
  version = "0.1.11";
  src = inputs.blockinfile;
  vendorHash = "sha256-Heh9WxJT6HS65CEW2pN8yHlo4dyMaEw9UImQ5zp8/gg=";
}
