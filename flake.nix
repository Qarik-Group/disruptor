{
  description = "Disruptor";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    flake-compat = {
      url = github:edolstra/flake-compat;
      flake = false;
    };
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-21.11";
    nixpkgs_latest.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs_latest, nixpkgs, flake-utils, ... }:
  flake-utils.lib.eachDefaultSystem (system:
  let
    pkgs = nixpkgs.legacyPackages.${system};
    pkgs_latest = nixpkgs.legacyPackages.${system};
    dev_shell = pkgs.stdenv.mkDerivation {
      name = "dev-shell";
      buildInputs = with pkgs; [
        cacert
        coreutils-full
        curlFull
        direnv
        # Add git client to shell, it reads host configuration
        git
        gnutar
        # Nix 2.5 (as the one from the installator)
        nixUnstable
        # Dynamically load nix envs
        nix-direnv
        shellcheck
      ];
      shellHook = ''
        export TERM=xterm
        # nix-shell --keep will refuse to retain a variable,
        # which is not exported in user shell, but which is 
        # set in the nix-shell.sh. 
        # Working around this issue takes a lot of effort
        # (detecting export, exporting and undoing exports
        # on shell closure).
        # This approach is more naive, but less
        # maintainance intensive.
        export DIRENV_CONFIG="$(pwd)/.cache"
        export NIX_CONF_DIR="$(pwd)/scripts"
        export NIX_USER_CONF_FILES=""
        export NIX_PATH="nixpkgs=$(pwd)/scripts/nixpkgs.nix"
        . ${pkgs.nix-direnv}/share/nix-direnv/direnvrc
        eval "$(direnv hook bash)"
      '';
      TMPDIR = "/tmp";
    };
  in {
      nixpkgs = pkgs;
      # DO NOT USE nix develop, as it is not hermetic
      # use nix-shell --pure, which loads devShell with out any settings from user env
      devShell = dev_shell;
    }
  );
}
