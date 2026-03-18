{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [

    # editors
    vscodium
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
