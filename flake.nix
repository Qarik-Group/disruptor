{
  description = "Disruptor";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    flake-compat = {
      url = github:edolstra/flake-compat;
      flake = false;
    };
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
    nixpkgs_latest.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-direnv.url = "github:nix-community/nix-direnv";
    nix-direnv.inputs = {
      nixpkgs.follows = "nixpkgs";
      flake-compat.follows = "flake-compat";
      flake-utils.follows = "flake-utils";
    };
    nixgl.url = "github:guibou/nixGL";
    nixgl.inputs = {
      nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs_latest, nixpkgs, nixgl, nix-direnv, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        # import <XXX> underneath this project
        # will not be able to use any of those
        # overlays.
        overlays = [ 
          nix-direnv.overlay
        ] ++ (
          # At the moment nixgl only supports x86_64-linux
          if system == "x86_64-linux" then [nixgl.overlay] else []
        );
        callArgs = { inherit system overlays; };
      in
      builtins.mapAttrs
        (n: v: import v callArgs)
        { inherit nixpkgs nixpkgs_latest; }
    );
}
