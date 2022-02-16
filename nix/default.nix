{
  system ? builtins.currentSystem,
  # Using <nixpkgs> due to Bazel nixpkgs_rules compat
  nixpkgs ? import <nixpkgs> {
    inherit system;
    config.allowUnfree = true;
  },
  crossTarget ? null,
  ...
}@args:

let
  readTree = import ./readTree { };
  readPackages = packagesArgs: readTree {
    args = packagesArgs;
    path = ./.;
    scopedArgs = {
      __findFile = _: _: throw "Do not import from NIX_PATH!";
    };
  };
  pkgs = if builtins.isNull crossTarget then nixpkgs else (builtins.getAttr crossTarget nixpkgs.pkgsCross);
in
readTree.fix (self: (readPackages {
  disruptor = self;
  # Compatiblity
  pkgs = pkgs;
  # Expose lib attribute to packages.
  lib = pkgs.lib;
  externalArgs = args;
}))
