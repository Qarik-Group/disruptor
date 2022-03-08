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
        gnutar
        # Nix 2.5 (as the one from the installator)
        nixUnstable
        # Dynamically load nix envs
        nix-direnv
        # Add git client to shell, it reads host configuration
        git
      ];
      shellHook = ''
        export TERM=xterm
        export DIRENV_CONFIG=$(pwd)/.cache
        export NIX_USER_CONF_FILES=${./scripts/nix.conf}
        . ${pkgs.nix-direnv}/share/nix-direnv/direnvrc
        eval "$(direnv hook bash)"
      '';
      TMPDIR = "/tmp";
    };
  in {
      # DO NOT USE nix develop, as it is not hermetic
      # use nix-shell --pure, which loads devShell with out any settings from user env
      devShell = dev_shell;
    }
  );
}
