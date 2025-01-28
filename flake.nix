{
  description = "Ansible development environment";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };
  };

  outputs = { self, nixpkgs, flake-utils, rust-overlay, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlays = [ (import rust-overlay) ];
        pkgs = import nixpkgs {
          inherit system overlays;
        };
        
        # Rust toolchain
        rustToolchain = pkgs.rust-bin.stable.latest.default.override {
          extensions = [ "rust-src" "rust-analyzer" ];
        };
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            # Ansible and Python
            ansible
            python3
            python3Packages.pip
            python3Packages.setuptools
            python3Packages.wheel
            
            # Go
            go
            gopls
            go-tools
            
            # Rust
            rustToolchain
            cargo
            rustc
            rust-analyzer
            pkg-config
            
            # Locales
            glibcLocales
          ];

          LOCALE_ARCHIVE = "${pkgs.glibcLocales}/lib/locale/locale-archive";
          
          shellHook = ''
            # Locale settings
            export LANG="en_US.UTF-8"
            export LC_ALL="en_US.UTF-8"
            export LOCALE_ARCHIVE="${pkgs.glibcLocales}/lib/locale/locale-archive"
            
            # Ensure the locale is available
            if ! locale -a | grep -q '^en_US.utf8$'; then
              echo "Generating en_US.UTF-8 locale..."
              ${pkgs.glibcLocales}/bin/localedef -i en_US -f UTF-8 en_US.UTF-8
            fi

            # Go settings
            export GOPATH=$HOME/go
            export PATH=$GOPATH/bin:$PATH
            
            # Python settings
            export PYTHONPATH="$PWD/src:$PYTHONPATH"
            
            # Rust settings
            export RUST_SRC_PATH=${rustToolchain}/lib/rustlib/src/rust/library

            echo "Development environment ready!"
            echo "Python version: $(python3 --version)"
            echo "Go version: $(go version)"
            echo "Rust version: $(rustc --version)"
          '';
        };
      });
}
