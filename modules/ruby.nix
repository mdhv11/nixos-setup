{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    ruby_3_3
    bundler
    libyaml
    gcc
    gnumake
    openssl
    zlib
    libffi
    pkg-config
  ];
}
