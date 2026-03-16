{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
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
    direnv
  ];

  programs.zsh.enable = true;
}