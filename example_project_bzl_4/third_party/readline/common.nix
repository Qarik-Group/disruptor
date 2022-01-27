{ pkgs, lib, stdenv, ... }:

let
  readlineStatic = pkgs.readline81.overrideAttrs (oldAttrs: rec {
    configureFlags = [
      "--enable-static"
      "--disable-shared"
    ];

    # static build, so don't need ncurses
    # (we also let Bazel handle the dependency)
    propagateBuildInputs = [];

    patches = [ 
      ./no-arch_only.patch
    ] ++ oldAttrs.upstreamPatches;
  });
in pkgs.symlinkJoin {
  name = "readline";
  paths = [ readlineStatic.out readlineStatic.dev ];
}
