# Hosts Layout

Create one folder per machine under `hosts/`.

Example:

```text
hosts/
  example/
    configuration.nix
  my-laptop/
    configuration.nix
    hardware-configuration.nix
```

Recommended workflow for a new machine:

1. Copy `hosts/template/configuration.nix` to `hosts/<hostname>/configuration.nix`.
2. Generate `hosts/<hostname>/hardware-configuration.nix` with `sudo nixos-generate-config --dir ./hosts/<hostname>`.
3. Replace the placeholder hostname, username, home directory, and git identity.
4. Add a matching `nixosConfigurations.<hostname>` entry in `flake.nix`.
