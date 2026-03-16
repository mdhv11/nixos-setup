{ self, pkgs, ... }:

{
  imports = [
    self.nixosModules.rails-react

    # Uncomment and adjust this on a real machine.
    # ./hardware-configuration.nix
  ];

  # Placeholder values so the example configuration evaluates cleanly.
  # Replace these with your actual hardware settings on a real machine.
  fileSystems."/" = {
    device = "none";
    fsType = "tmpfs";
  };

  boot.loader.grub.enable = false;
  boot.isContainer = true;

  networking.hostName = "rails-react-dev";
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

    programs.git.settings.user.name = "Your Name";
    programs.git.settings.user.email = "you@example.com";
  };

  system.stateVersion = "24.05";
}
