{ self, pkgs, ... }:

{
  imports = [
    self.nixosModules.rails-react
    # Optional desktop apps and GNOME session:
    # self.nixosModules.desktop
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "change-me";
  time.timeZone = "Asia/Kolkata";

  users.users.dev = {
    isNormalUser = true;
    description = "Development User";
    extraGroups = [
      "wheel"
      "networkmanager"
      "docker"
    ];
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;
  networking.networkmanager.enable = true;

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.dev = {
    imports = [ self.homeManagerModules.rails-react ];

    home.username = "dev";
    home.homeDirectory = "/home/dev";

    programs.git.user.name = "Your Name";
    programs.git.user.email = "you@example.com";
  };

  system.stateVersion = "24.05";
}
