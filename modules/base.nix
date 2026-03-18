{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    kitty
    git
    curl
    wget
    unzip
    htop
    ripgrep
    fd
    tree
    jq
    tmux
    gnupg
    ffmpeg
    neofetch
  ];

  programs.zsh.enable = true;
}