{
  description = "NixOS and dev-shell setup for Ruby on Rails with React";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      devShells = forAllSystems (system:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        {
          default = pkgs.mkShell {
            packages = with pkgs; [
              ruby_3_3
              bundler
              nodejs_22
              yarn
              nodePackages.pnpm
              postgresql_15
              redis
              sqlite
              imagemagick
              libyaml
              openssl
              libffi
              zlib
              gcc
              gnumake
              pkg-config
              git
              curl
              jq
            ];

            shellHook = ''
              echo "Rails + React development shell"
              echo "Ruby: $(ruby --version)"
              echo "Node: $(node --version)"
            '';
          };
        });

      nixosModules.rails-react = import ./modules/rails-react.nix;
      homeManagerModules.rails-react = import ./home/home.nix;

      nixosConfigurations.example = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit self;
        };
        modules = [
          ./hosts/example/configuration.nix
          home-manager.nixosModules.home-manager
        ];
      };
    };
}
