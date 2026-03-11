# Copyright © Anterior
#
# Licensed under AGPLv3-only. See README for year and details.

# Elasticmq module for NixOS.  No frills just local ephemeral host.

{
  lib,
  pkgs,
  config,
  ...
}:
{
  options.services.elasticmq = {
    enable = lib.mkEnableOption "elasticmq-server-bin";
    package = lib.mkPackageOption pkgs "elasticmq-server-bin" { };
    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
    port = lib.mkOption {
      type = lib.types.port;
      default = 9324;
      # TODO: changing the port is super ugly. see
      # https://github.com/juspay/services-flake/blob/main/nix/services/elasticmq.nix#L87-L103
      # readonly for now.
      readOnly = true;
    };
  };
  config =
    let
      cfg = config.services.elasticmq;
    in
    lib.mkIf cfg.enable {
      # systemd, therefore not nixng compatible
      systemd.services.elasticmq = {
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        script = ''
          exec ${lib.getExe cfg.package}
        '';
        serviceConfig = {
          Type = "simple";
          User = "elasticmq";
          Group = "elasticmq";
        };
      };
      users.users.elasticmq = {
        group = "elasticmq";
        home = "/var/lib/elasticmq";
        useDefaultShell = true;
        isSystemUser = true;
        createHome = true;
      };
      users.groups.elasticmq = { };
      networking.firewall.allowedTCPPorts = lib.optionals cfg.openFirewall [ cfg.port ];
    };
}
