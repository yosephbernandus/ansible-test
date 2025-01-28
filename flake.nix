{
  description = "Ansible development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            ansible
            python3
            glibcLocales
          ];

          LOCALE_ARCHIVE = "${pkgs.glibcLocales}/lib/locale/locale-archive";

          shellHook = ''
            export LANG="en_US.UTF-8"
            export LC_ALL="en_US.UTF-8"
            export LOCALE_ARCHIVE="${pkgs.glibcLocales}/lib/locale/locale-archive"
            
            # Ensure the locale is available
            if ! locale -a | grep -q '^en_US.utf8$'; then
              echo "Generating en_US.UTF-8 locale..."
              ${pkgs.glibcLocales}/bin/localedef -i en_US -f UTF-8 en_US.UTF-8
            fi
          '';
        };
      });
}
