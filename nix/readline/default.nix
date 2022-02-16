{ disruptor, pkgs, lib, ... }:

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
in
pkgs.stdenv.mkDerivation {
  name = "readline-static.bzl";
  buildInputs = [
    readlineStatic
    readlineStatic.dev
  ];

  phases = [
    "installPhase"
  ];

  installPhase = ''
    mkdir $out
    cp ${disruptor.bazelHelpers.createCppBuildFile "readline"} $out/BUILD.bazel
    cp -R ${readlineStatic}/* $out/
    cp -R ${readlineStatic.dev}/include $out/
  '';
}
