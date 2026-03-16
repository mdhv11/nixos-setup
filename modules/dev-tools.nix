{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [

    # editors
    vscode
    neovim

    # rails debugging
    sqlite
    imagemagick

    # network
    httpie

    # containers
    docker-compose
  ];
}