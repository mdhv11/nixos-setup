{ pkgs, ... }:

{
  services.postgresql.enable = true;
  services.postgresql.package = pkgs.postgresql_15;

  services.redis.servers.default.enable = true;
}
