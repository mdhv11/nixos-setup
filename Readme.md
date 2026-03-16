# Rails + React Nix Setup

This repo now provides two separate ways to set up a Ruby on Rails + React environment on NixOS.

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
- `home/home.nix`: reusable Home Manager module
- `hosts/example/configuration.nix`: example full system configuration

### To use it on a real machine

1. Copy `hosts/example/configuration.nix` into your own host definition.
2. Set your actual username, home directory, git name, and git email.
3. Replace the placeholder root filesystem and boot settings with your generated `hardware-configuration.nix`, obtained by `sudo nixos-generate-config`
4. Build it with:

```bash
sudo nixos-rebuild switch --flake .#example
```

## Notes

- The dev shell is generic and should work directly after cloning.
- The full NixOS version is intentionally an example, because machine configs usually need host-specific hardware settings and a real username.
