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
    pkgs_latest = nixpkgs_latest.legacyPackages.${system};
    dev_shell = import ./shell.nix {
      pkgs = nixpkgs.legacyPackages.${system};
      pkgs_latest = nixpkgs_latest.legacyPackages.${system};
    };
  in {
      nixpkgs = pkgs;
      nixpkgs_latest = pkgs_latest;
      # DO NOT USE nix develop, as it is not hermetic
      # use nix-shell --pure, which loads devShell with out any settings from user env
      devShell = dev_shell;
    }
  );
}
