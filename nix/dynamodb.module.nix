# Copyright © Anterior
#
# Licensed under AGPLv3-only. See README for year and details.

# Dynamodb module for NixOS.  No frills just local ephemeral host.

{
  lib,
  pkgs,
  config,
  ...
}:
{
  options.services.dynamodb = {
    enable = lib.mkEnableOption "dynamodb";
    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
    port = lib.mkOption {
      type = lib.types.port;
      default = 8000;
    };
  };
  config =
    let
      cfg = config.services.dynamodb;
    in
    lib.mkIf cfg.enable {
      systemd.services.dynamodb = {
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        script = ''
          exec ${lib.getExe pkgs.dynamodb-local} -dbPath /var/lib/dynamodb -port ${toString cfg.port}
        '';
        serviceConfig = {
          Type = "simple";
          User = "dynamodb";
          Group = "dynamodb";
        };
      };
      users.users.dynamodb = {
        group = "dynamodb";
        home = "/var/lib/dynamodb";
        useDefaultShell = true;
        isSystemUser = true;
        createHome = true;
      };
      users.groups.dynamodb = { };
      networking.firewall.allowedTCPPorts = lib.optionals cfg.openFirewall [ cfg.port ];
    };
}
