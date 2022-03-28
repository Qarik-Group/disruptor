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
        overlays = [ nix-direnv.overlay ];
        callArgs = { inherit system overlays; };
      in
      { inherit callArgs; } //
      builtins.mapAttrs
        (n: v: import v callArgs)
        { inherit nixpkgs nixpkgs_latest; }
    );
}
