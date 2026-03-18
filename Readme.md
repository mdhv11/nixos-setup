# Rails + React Nix Setup

This repo provides two separate ways to set up a Ruby on Rails + React environment on NixOS.

## Version 1: Portable dev shell

Use this if you want a project-local development environment without changing your full system configuration.

Clone the repo and run:

```bash
nix develop
```

If you use `direnv`, add this to your Rails project `.envrc`:

```bash
use flake /path/to/nix-setup
```

The dev shell includes:

- Ruby 3.3
- Bundler
- Node.js 22
- Yarn
- pnpm
- PostgreSQL 15
- Redis
- SQLite
- ImageMagick
- common native build tools for gems

On shell entry it also initializes and starts local PostgreSQL and Redis instances under `.devenv/`.

Useful defaults exposed by the shell:

- PostgreSQL data dir: `.devenv/postgres`
- PostgreSQL socket dir: `.devenv`
- PostgreSQL port: `54329`
- Redis dir: `.devenv/redis`
- Redis port: `6380`

This is the simplest "clone and run one command" workflow.

## Version 2: Full NixOS configuration

Use this if you want the repo to define your machine-level development setup.

The reusable module is exposed as:

```bash
nix flake show
```

Look for:

- `nixosModules.rails-react`
- `homeManagerModules.rails-react`
- `nixosConfigurations.example`

### Included files

- `modules/rails-react.nix`: reusable NixOS module that imports the base, Ruby, Node, database, Docker, and dev-tool modules
- `modules/desktop.nix`: optional GNOME desktop and GUI app module
- `home/home.nix`: reusable Home Manager module
- `hosts/template/configuration.nix`: template for creating a real machine config under `hosts/<hostname>/`
- `hosts/example/configuration.nix`: example full system configuration

### Recommended host structure

Keep one folder per machine:

```text
hosts/
  template/
    configuration.nix
  my-laptop/
    configuration.nix
    hardware-configuration.nix
  workstation/
    configuration.nix
    hardware-configuration.nix
```

### To create a config for a real machine

1. Create a host directory:

```bash
mkdir -p hosts/my-laptop
cp hosts/template/configuration.nix hosts/my-laptop/configuration.nix
```

2. Generate the hardware config on the target machine:

```bash
sudo nixos-generate-config --dir ./hosts/my-laptop
```

This creates:

- `hosts/my-laptop/hardware-configuration.nix`

3. Edit `hosts/my-laptop/configuration.nix` and change:

- `networking.hostName`
- `users.users.<name>`
- `home-manager.users.<name>`
- `home.username`
- `home.homeDirectory`
- git name and email
- boot loader settings if your machine does not use UEFI + systemd-boot

If you want a desktop environment on that machine, uncomment this import in the host config:

```nix
self.nixosModules.desktop
```

4. Add a matching host entry in `flake.nix`. Example:

```nix
nixosConfigurations.my-laptop = nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  specialArgs = { inherit self; };
  modules = [
    ./hosts/my-laptop/configuration.nix
    home-manager.nixosModules.home-manager
  ];
};
```

5. Build it with:

```bash
sudo nixos-rebuild switch --flake .#my-laptop
```

## Notes

- The dev shell is generic and should work directly after cloning.
- `hosts/example/configuration.nix` is only there as an evaluable example for `nix flake check`.
