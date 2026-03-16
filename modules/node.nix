{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    nodejs_22
    yarn
    nodePackages.pnpm
  ];
}
