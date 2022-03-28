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
    nix-direnv.url = "github:nix-community/nix-direnv";
    nix-direnv.inputs = {
      nixpkgs.follows = "nixpkgs";
      flake-compat.follows = "flake-compat";
      flake-utils.follows = "flake-utils";
    };
  };

  outputs = { self, nixpkgs_latest, nixpkgs, nix-direnv, flake-utils, ... }:
  flake-utils.lib.eachDefaultSystem (system:
  let
    overlays = [
      (self: super: {
        nix-direnv = nix-direnv.defaultPackage.${system};
      })
    ];
    pkgs = (import nixpkgs {
      inherit system overlays;
    });
    pkgs_latest = (import nixpkgs_latest {
      inherit system overlays;
    });
    dev_shell = import ./shell.nix {
      inherit pkgs pkgs_latest;
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
