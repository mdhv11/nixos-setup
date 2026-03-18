{
  description = "NixOS and dev-shell setup for Ruby on Rails with React";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
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
              export DEVENV_ROOT="$PWD/.devenv"
              export PGDATA="$DEVENV_ROOT/postgres"
              export PGHOST="$DEVENV_ROOT"
              export PGPORT="54329"
              export REDIS_DIR="$DEVENV_ROOT/redis"
              export REDIS_PORT="6380"

              mkdir -p "$DEVENV_ROOT" "$REDIS_DIR"

              if [ ! -f "$PGDATA/PG_VERSION" ]; then
                initdb "$PGDATA" >/dev/null
              fi

              if ! pg_ctl -D "$PGDATA" status >/dev/null 2>&1; then
                pg_ctl -D "$PGDATA" -l "$PGDATA/logfile" -o "-k $PGHOST -p $PGPORT" start >/dev/null
              fi

              if [ ! -f "$REDIS_DIR/redis.conf" ]; then
                cat > "$REDIS_DIR/redis.conf" <<EOF
port $REDIS_PORT
bind 127.0.0.1
dir $REDIS_DIR
pidfile $REDIS_DIR/redis.pid
daemonize yes
save ""
appendonly no
EOF
              fi

              if [ ! -f "$REDIS_DIR/redis.pid" ] || ! kill -0 "$(cat "$REDIS_DIR/redis.pid" 2>/dev/null)" 2>/dev/null; then
                redis-server "$REDIS_DIR/redis.conf" >/dev/null 2>&1 || true
              fi

              echo "Rails + React development shell"
              echo "Ruby: $(ruby --version)"
              echo "Node: $(node --version)"
              echo "PostgreSQL socket: $PGHOST/.s.PGSQL.$PGPORT"
              echo "Redis: 127.0.0.1:$REDIS_PORT"
            '';
          };
        });

      nixosModules.rails-react = import ./modules/rails-react.nix;
      nixosModules.desktop = import ./modules/desktop.nix;
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
