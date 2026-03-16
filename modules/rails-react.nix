{ ... }:

{
  imports = [
    ./base.nix
    ./ruby.nix
    ./node.nix
    ./dev-tools.nix
    ./databases.nix
    ./docker.nix
  ];
}
